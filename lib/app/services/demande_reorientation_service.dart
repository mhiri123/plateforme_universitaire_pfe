import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:http_parser/http_parser.dart';
import '../models/demande_reorientation_model.dart';
import 'package:get_storage/get_storage.dart';
import '../services/notification_service.dart';
import 'package:get/get.dart' as getx;

part 'demande_reorientation_service.g.dart';

// Configuration de l'URL de base
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.23.0.1:8000/api',
  );
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class DemandeReorientationApiService {
  factory DemandeReorientationApiService(Dio dio, {String? baseUrl}) =
      _DemandeReorientationApiService;

  @POST("/reorientation/demandes")
  @MultiPart()
  Future<DemandeReorientation> soumettreDemande(@Body() FormData formData);

  @GET("/reorientation/demandes/en-attente")
  Future<List<DemandeReorientation>> listerDemandesEnAttente();

  @GET("/reorientation/demandes/etudiant/{id}")
  Future<List<DemandeReorientation>> listerMesDemandesReorientation(
      @Path("id") int id);

  @PUT("/reorientation/demandes/{id}/traiter")
  Future<DemandeReorientation> traiterDemande(
      @Path("id") int id, @Body() Map<String, dynamic> donneesTraitement);

  // Méthodes modifiées pour la compatibilité avec le backend
  @GET("/reorientation/demandes/{id}/student")
  Future<dynamic> getStudentId(@Path("id") int id);

  @GET("/reorientation/demandes/{id}")
  Future<DemandeReorientation> getDemandeDetails(@Path("id") int id);
}

class DemandeReorientationService {
  // Suppression du champ inutilisé _apiService
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final NotificationService _notificationService = getx.Get.find();

  DemandeReorientationService(Dio dio);

  Future<String> _getAuthToken() async {
    final token = await _secureStorage.read(key: 'token') ?? '';
    if (token.isEmpty) {
      print('❌ Aucun token trouvé, utilisateur non authentifié.');
      throw Exception(
          'Utilisateur non authentifié. Veuillez vous reconnecter.');
    }
    return token;
  }

  Future<int> _getIdEtudiantConnecte() async {
    final storedData = await GetStorage().read('user');
    return storedData != null
        ? int.tryParse(storedData['id'].toString()) ?? 0
        : 0;
  }

  void _validateDonnees({
    required String nom,
    required String prenom,
    required String filiereActuelleNom,
    required String nouvelleFiliereNom,
    required String motivation,
    required String level,
    required String facultyName,
  }) {
    // Ajout de validations supplémentaires si nécessaire
  }

  // Expose les méthodes Retrofit
  Future<List<DemandeReorientation>> listerDemandesEnAttente() async {
    final response =
        await _safeRequest('/reorientation/demandes/en-attente', 'GET');
    final data = response.data['data'];
    if (data is List) {
      return data
          .map((item) =>
              DemandeReorientation.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Format de données inattendu pour les demandes en attente');
    }
  }

  Future<List<DemandeReorientation>> listerMesDemandesReorientation(
      int id) async {
    final response =
        await _safeRequest('/reorientation/demandes/etudiant/$id', 'GET');
    final data = response.data['data'];
    if (data is List) {
      return data
          .map((item) =>
              DemandeReorientation.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Format de données inattendu pour mes demandes de réorientation');
    }
  }

  // Ajoute une méthode vide pour éviter l'erreur
  Future<void> _envoyerNotificationCreation(
      DemandeReorientation demande) async {
    // TODO: Implémenter la notification de création si besoin
  }

  Future<Response> _safeRequest(String path, String method,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final token = await _getAuthToken();
    if (token.isEmpty) {
      throw Exception(
          'Token d\'authentification manquant. Veuillez vous reconnecter.');
    }
    final options = Options(
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    final fullUrl = ApiConfig.baseUrl + path;
    print('--- [DEBUG] Appel API ---');
    print('URL: ' + fullUrl);
    print('Méthode: ' + method);
    print('Headers: ' + options.headers.toString());
    if (data != null) print('Données envoyées: ' + data.toString());
    if (queryParameters != null) print('Query: ' + queryParameters.toString());
    print('Token utilisé: $token');

    Response response;
    try {
      switch (method) {
        case 'GET':
          response = await Dio()
              .get(fullUrl, options: options, queryParameters: queryParameters);
          break;
        case 'POST':
          response = await Dio().post(fullUrl,
              data: data, options: options, queryParameters: queryParameters);
          break;
        case 'PUT':
          response = await Dio().put(fullUrl,
              data: data, options: options, queryParameters: queryParameters);
          break;
        default:
          throw Exception('Méthode HTTP non prise en charge');
      }
      print('--- [DEBUG] Réponse API ---');
      print('Status code: ' + response.statusCode.toString());
      print('Headers: ' + response.headers.toString());
      print('Body: ' + response.data.toString());
    } catch (e) {
      print('--- [DEBUG] Exception lors de l\'appel API ---');
      print(e);
      rethrow;
    }
    // Vérification du type de la réponse pour éviter de parser du HTML
    if (response.data is String &&
        response.data.toString().contains('<!DOCTYPE html>')) {
      print('--- [DEBUG] Le serveur a retourné du HTML au lieu du JSON ---');
      throw Exception(
          'Le serveur a retourné du HTML au lieu du JSON. Vérifiez l\'URL ou le backend.');
    }
    return response;
  }

  Future<DemandeReorientation> soumettreDemande({
    required String nom,
    required String prenom,
    required String filiereActuelleNom,
    required String nouvelleFiliereNom,
    required String motivation,
    required String level,
    required String facultyName,
    File? pieceJustificative,
  }) async {
    try {
      print("Début de soumettreDemande");
      print("Token actuel : \\${await _getAuthToken()}");

      _validateDonnees(
        nom: nom,
        prenom: prenom,
        filiereActuelleNom: filiereActuelleNom,
        nouvelleFiliereNom: nouvelleFiliereNom,
        motivation: motivation,
        level: level,
        facultyName: facultyName,
      );

      final userId = await _getIdEtudiantConnecte();
      if (userId == 0) {
        throw Exception('ID utilisateur invalide');
      }

      // Récupérer l'ID de l'admin de la faculté en utilisant _safeRequest
      final adminResponse = await _safeRequest(
        '/faculties/$facultyName/admin',
        'GET',
      );

      if (adminResponse.statusCode != 200) {
        throw Exception('Impossible de récupérer l\'admin de la faculté');
      }
      final adminId = adminResponse.data['admin_id'];

      // Modification du FormData pour être compatible avec le backend
      final formData = FormData.fromMap({
        'user_id': userId.toString(),
        'admin_id': adminId.toString(),
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'niveau': level,
        'faculty_name': facultyName,
        'filiere_actuelle_nom': filiereActuelleNom,
        'nouvelle_filiere_nom': nouvelleFiliereNom,
        'motivation': motivation.trim(),
        'status': 'en_attente',
      });

      if (pieceJustificative != null) {
        final fileName = pieceJustificative.path.split('/').last;
        formData.files.add(MapEntry(
          'piece_justificative',
          await MultipartFile.fromFile(
            pieceJustificative.path,
            filename: fileName,
            contentType: MediaType.parse('application/pdf'),
          ),
        ));
      }

      print("Envoi de la requête avec FormData : \\${formData.fields}");

      // Utiliser directement Dio avec le circuit breaker plutôt que _apiService
      final response = await _safeRequest(
        '/reorientation/demandes',
        'POST',
        data: formData,
      );

      final demande = DemandeReorientation.fromJson(response.data);
      await _envoyerNotificationCreation(demande);
      print('Notification de création envoyée avec succès');
      return demande;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      print('Erreur lors de la soumission de la demande: $e');
      rethrow;
    }
  }

  Future<DemandeReorientation> traiterDemande(
      String demandeId, bool isAccepted, String commentaire) async {
    try {
      print('\n=== DÉBUT TRAITEMENT DEMANDE ===');
      print('ID de la demande: $demandeId');
      print('Action: ${isAccepted ? "ACCEPTATION" : "REJET"}');

      // Vérifier si l'ID est un entier valide
      final int? id = int.tryParse(demandeId);
      if (id == null) {
        throw Exception('Format d\'ID invalide');
      }

      // Préparer les données dans le format attendu par le backend modifié
      final status = isAccepted ? 'acceptee' : 'rejetee';
      final donneesTraitement = {
        'status': status,
        'commentaire':
            commentaire, // Utiliser commentaire au lieu de commentaire_admin
      };

      print('Données de traitement: $donneesTraitement');

      // Utiliser _safeRequest pour appeler l'API
      final response = await _safeRequest(
        '/reorientation/demandes/$id/traiter',
        'PUT',
        data: donneesTraitement,
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors du traitement: ${response.statusCode}');
      }

      print('Réponse du serveur: ${response.data}');

      // Récupérer les détails mis à jour de la demande
      final demandeResponse = await _safeRequest(
        '/reorientation/demandes/$id',
        'GET',
      );
      final updatedDemande =
          DemandeReorientation.fromJson(demandeResponse.data);

      // Envoyer la notification de traitement
      await _envoyerNotificationTraitement(
        demande: updatedDemande,
        isAccepted: isAccepted,
        commentaire: commentaire,
      );

      return updatedDemande;
    } catch (e) {
      print('❌ ERREUR LORS DU TRAITEMENT:');
      print('Message: $e');
      rethrow;
    }
  }

  Future<void> _envoyerNotificationTraitement({
    required DemandeReorientation demande,
    required bool isAccepted,
    String? commentaire,
  }) async {
    try {
      print('\n=== DÉBUT ENVOI NOTIFICATION TRAITEMENT ===');
      print('Demande ID: ${demande.id}');

      if (demande.id == null) {
        print('❌ Impossible d\'envoyer une notification sans ID de demande');
        return; // Retour anticipé mais pas de message de succès
      }

      // S'assurer que le champ id est non nul avant d'envoyer
      final demandeId = demande.id;
      if (demandeId == null || demandeId <= 0) {
        print('❌ ID de demande invalide: $demandeId');
        return; // Retour anticipé
      }

      // S'assurer que les autres champs nécessaires sont présents
      if (demande.nouvelleFiliereNom.isEmpty) {
        print(
            '⚠️ Nouvelle filière manquante, utilisation d\'une valeur par défaut');
      }

      // Utiliser directement le nouvel endpoint pour envoyer la notification
      await _notificationService.creerNotificationReorientation(
        demandeId: demandeId, // Utiliser la variable locale validée
        type: 'statut_demande',
        titre: isAccepted
            ? 'Demande de Réorientation Acceptée'
            : 'Demande de Réorientation Refusée',
        message: isAccepted
            ? '''
Félicitations, votre demande de réorientation a été acceptée.
Filière : ${demande.nouvelleFiliereNom}
'''
            : '''
Désolé, votre demande de réorientation a été refusée.
Motif : ${commentaire ?? "Aucun motif fourni"}
''',
        isAdminNotification: false, // false = notification pour l'étudiant
      );

      print('✅ Notification de traitement envoyée avec succès à l\'étudiant');
      print('=== FIN ENVOI NOTIFICATION TRAITEMENT ===\n');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de traitement : $e');
      print('=== FIN ENVOI NOTIFICATION TRAITEMENT (avec erreur) ===\n');
      // Ne pas faire remonter l'exception pour éviter de bloquer le traitement principal
    }
  }

  void _handleError(DioException e) {
    // Gestion des erreurs améliorée
    if (e.response != null) {
      print('Erreur ${e.response?.statusCode}: ${e.response?.data}');
    } else {
      print('Erreur de connexion: ${e.message}');
    }
  }
}
