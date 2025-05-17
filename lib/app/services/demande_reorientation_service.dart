import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import 'package:http_parser/http_parser.dart';
import '../models/demande_reorientation_model.dart';
import 'package:get_storage/get_storage.dart';

part 'demande_reorientation_service.g.dart';

// Configuration de l'URL de base
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.17:8000/api',
  );
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class DemandeReorientationApiService {
  factory DemandeReorientationApiService(Dio dio, {String? baseUrl}) =
      _DemandeReorientationApiService;

  @POST("/reorientation/demandes")
  @MultiPart()
  Future<DemandeReorientation> soumettreDemande(@Body() FormData formData);

  @GET("/reorientation/demandes")
  Future<dynamic> listerToutesDemandes();
  
  @GET("/reorientation/demandes/en-attente")
  Future<dynamic> listerDemandesEnAttente();

  @GET("/reorientation/demandes/etudiant/{id}")
  Future<dynamic> listerMesDemandesReorientation(@Path("id") int id);

  @PUT("/reorientation/demandes/{id}/traiter")
  Future<DemandeReorientation> traiterDemande(
      @Path("id") int id, @Body() Map<String, dynamic> donneesTraitement);
}

class DemandeReorientationService {
  final DemandeReorientationApiService _apiService;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  );

  DemandeReorientationService({
    Dio? dio,
    DemandeReorientationApiService? apiService,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ?? Dio(_defaultOptions),
        _apiService = apiService ?? DemandeReorientationApiService(dio ?? Dio(_defaultOptions)),
        _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _configureDio();
  }

  void _configureDio() {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
        onResponse: _onResponse,
      ),
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    print('Erreur Dio: ${error.message}');
    print('URL: ${error.requestOptions.uri}');
    print('Méthode: ${error.requestOptions.method}');
    print('Headers: ${error.requestOptions.headers}');
    if (error.response != null) {
      print('Status code: ${error.response?.statusCode}');
      print('Response data: ${error.response?.data}');
    }
    handler.next(error);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Réponse reçue: ${response.statusCode}');
    print('URL: ${response.requestOptions.uri}');
    print('Data: ${response.data}');
    handler.next(response);
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
      print("Token actuel : ${await _getAuthToken()}");
      
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

      // Récupérer l'ID de l'admin de la faculté
      final adminResponse = await _dio.get('/faculties/$facultyName/admin');
      if (adminResponse.statusCode != 200) {
        throw Exception('Impossible de récupérer l\'admin de la faculté');
      }
      final adminId = adminResponse.data['admin_id'];

      final formData = FormData.fromMap({
        'user_id': userId.toString(),
        'admin_id': adminId.toString(), // Utiliser l'ID de l'admin de la faculté
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

      print("Envoi de la requête avec FormData : ${formData.fields}");
      final response = await _apiService.soumettreDemande(formData);
      await _envoyerNotificationCreation(response);
      print('Notification de création envoyée avec succès');
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      print('Erreur lors de la soumission de la demande: $e');
      rethrow;
    }
  }

  Future<List<DemandeReorientation>> listerDemandesEnAttente() async {
    try {
      print('Tentative de récupération des demandes en attente...');
      
      // Récupérer le rôle de l'utilisateur connecté
      final userRole = await _getUserRole();
      print('Rôle utilisateur: $userRole');
      
      // Pour tous les utilisateurs, utiliser directement l'endpoint /demandes/en-attente
      print('Utilisation de l\'endpoint /reorientation/demandes/en-attente');
      
      // Appeler directement l'API backend qui filtre déjà les demandes en attente
      final response = await _apiService.listerDemandesEnAttente();
      print('Réponse reçue du serveur: $response');
      
      if (response is Map<String, dynamic> && response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> demandesData = response['data'];
        final List<DemandeReorientation> demandesEnAttente = demandesData
            .map((data) => DemandeReorientation.fromJson(data))
            .toList();
        
        print('${demandesEnAttente.length} demandes en attente reçues du serveur');
        
        // Log des détails de chaque demande en attente
        for (var demande in demandesEnAttente) {
          print('Demande en attente trouvée:');
          print('- ID: ${demande.id}');
          print('- Nom: ${demande.nom}');
          print('- Prénom: ${demande.prenom}');
          print('- Filière actuelle: ${demande.filiereActuelleNom}');
          print('- Nouvelle filière: ${demande.nouvelleFiliereNom}');
          print('- Faculté: ${demande.facultyName}');
          print('- Statut: ${demande.statut}');
        }
        
        return demandesEnAttente;
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de la récupération des demandes:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la récupération des demandes: $e');
      rethrow;
    }
  }

  Future<List<DemandeReorientation>> listerMesDemandesReorientation(int idEtudiant) async {
    try {
      print('Tentative de récupération des demandes pour l\'étudiant $idEtudiant');
      final response = await _apiService.listerMesDemandesReorientation(idEtudiant);
      print('Réponse reçue du serveur: $response');
      
      if (response is Map<String, dynamic> && response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> demandesData = response['data'];
        final demandes = demandesData
            .map((data) => DemandeReorientation.fromJson(data))
            .toList();
        
        print('${demandes.length} demandes récupérées');
        return demandes;
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Erreur lors de la récupération des demandes:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue: $e');
      rethrow;
    }
  }

  Future<DemandeReorientation> traiterDemande({
    required DemandeReorientation demande,
    required bool isAccepted,
    String? commentaire,
  }) async {
    try {
      print('\n=== DÉBUT TRAITEMENT DEMANDE SERVICE ===');
      print('ID de la demande: ${demande.id}');
      print('Action: ${isAccepted ? "ACCEPTATION" : "REJET"}');
      
      // Vérifier que l'ID existe
      if (demande.id == null) {
        throw Exception('ID de la demande manquant');
      }

      // Préparer les données dans le format attendu par le serveur
      final status = isAccepted ? 'acceptee' : 'rejetee';
      final donneesTraitement = {
        'statut': status,  // Utiliser 'statut' (français) au lieu de 'status' (anglais)
        'commentaire_admin': commentaire ?? '',
        'date_traitement': DateTime.now().toIso8601String(),
      };

      print('\nDonnées envoyées au serveur:');
      print('- Statut: $status');
      print('- Commentaire: ${donneesTraitement['commentaire_admin']}');
      print('- Date: ${donneesTraitement['date_traitement']}');
      print('- URL: ${ApiConfig.baseUrl}/reorientation/demandes/${demande.id}/traiter');
      
      // Vérifier le token avant l'envoi
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant');
      }
      
      print('\nToken présent, envoi de la requête...');
      
      final result = await _apiService.traiterDemande(
        demande.id!,
        donneesTraitement,
      );

      if (result == null) {
        throw Exception('Réponse invalide du serveur');
      }

      print('\nRésultat du traitement:');
      print('- Nouveau statut: ${result.statut}');
      print('- Commentaire: ${result.commentaireAdmin}');
      print('- Date de traitement: ${result.dateTraitement}');

      // Envoyer la notification seulement si le traitement a réussi
      try {
        await _envoyerNotificationTraitement(
          demande: result,
          isAccepted: isAccepted,
          commentaire: commentaire,
        );
        print('Notification de traitement envoyée avec succès');
      } catch (e) {
        print('⚠️ Erreur lors de l\'envoi de la notification: $e');
        // Ne pas bloquer le processus si la notification échoue
      }

      print('=== FIN TRAITEMENT DEMANDE SERVICE ===\n');
      return result;
    } on DioException catch (e) {
      print('\n❌ ERREUR DIO DÉTAILLÉE:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Méthode: ${e.requestOptions.method}');
      print('Headers: ${e.requestOptions.headers}');
      print('Data: ${e.requestOptions.data}');
      
      if (e.response != null) {
        print('\nRéponse du serveur:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        
        // Gérer les différents codes d'erreur
        switch (e.response?.statusCode) {
          case 400:
            throw Exception('Données invalides. Veuillez vérifier les informations.');
          case 401:
            throw Exception('Session expirée. Veuillez vous reconnecter.');
          case 403:
            throw Exception('Accès non autorisé.');
          case 404:
            throw Exception('Demande non trouvée.');
          case 422:
            final errors = e.response?.data['errors'] as Map<String, dynamic>?;
            if (errors != null && errors.containsKey('status')) {
              throw Exception('Statut invalide: ${errors['status'].first}');
            }
            throw Exception('Données invalides: ${e.response?.data['message'] ?? 'Format incorrect'}');
          case 500:
            throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
          default:
            throw Exception('Erreur lors du traitement de la demande: ${e.response?.data['message'] ?? e.message}');
        }
      }
      
      throw Exception('Erreur de connexion: ${e.message}');
    } catch (e, stackTrace) {
      print('\n❌ ERREUR INATTENDUE:');
      print('Message: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
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
    final validationErrors = <String>[];

    if (nom.trim().isEmpty) {
      validationErrors.add('Le nom est requis');
    }
    if (prenom.trim().isEmpty) {
      validationErrors.add('Le prénom est requis');
    }
    if (filiereActuelleNom.trim().isEmpty) {
      validationErrors.add('La filière actuelle est requise');
    }
    if (nouvelleFiliereNom.trim().isEmpty) {
      validationErrors.add('La nouvelle filière est requise');
    }
    if (filiereActuelleNom.trim() == nouvelleFiliereNom.trim()) {
      validationErrors.add('La nouvelle filière doit être différente de la filière actuelle');
    }
    if (motivation.trim().length < 10) {
      validationErrors.add('La motivation doit contenir au moins 10 caractères');
    }
    if (level.trim().isEmpty) {
      validationErrors.add('Le niveau est requis');
    }
    if (facultyName.trim().isEmpty) {
      validationErrors.add('La faculté est requise');
    }

    if (validationErrors.isNotEmpty) {
      throw ArgumentError(validationErrors.join('\n'));
    }
  }

  Future<void> _envoyerNotificationCreation(DemandeReorientation demande) async {
    try {
      // Récupérer l'ID de l'admin de la faculté
      final adminResponse = await _dio.get('/faculties/${demande.facultyName}/admin');
      if (adminResponse.statusCode != 200) {
        throw Exception('Impossible de récupérer l\'admin de la faculté');
      }
      final adminId = adminResponse.data['admin_id'];

      final response = await _dio.post('/notifications', data: {
        'type': 'DEMANDE_REORIENTATION_CREATION',
        'destinataire_id': adminId,
        'user_id': demande.id,
        'titre': 'Nouvelle Demande de Réorientation',
        'message': '''
Une nouvelle demande de réorientation a été soumise :
Étudiant : ${demande.prenom} ${demande.nom}
Filière actuelle : ${demande.filiereActuelleNom}
Nouvelle filière souhaitée : ${demande.nouvelleFiliereNom}
Niveau : ${demande.level}
Faculté : ${demande.facultyName}
Statut : En attente de traitement
''',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('⚠️ Notification non envoyée: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de création : ${e.message}');
      if (e.response != null) {
        print('Détails de l\'erreur: ${e.response?.data}');
      }
    } catch (e) {
      print('❌ Erreur inattendue lors de l\'envoi de la notification : $e');
    }
  }

  Future<void> _envoyerNotificationTraitement({
    required DemandeReorientation demande,
    required bool isAccepted,
    String? commentaire,
  }) async {
    try {
      final response = await _dio.post('/notifications', data: {
        'type': 'DEMANDE_REORIENTATION_TRAITEMENT',
        'user_id': demande.id,
        'titre': isAccepted
            ? 'Demande de Réorientation Acceptée'
            : 'Demande de Réorientation Refusée',
        'message': isAccepted
            ? '''
Félicitations, votre demande de réorientation a été acceptée.
Filière : ${demande.nouvelleFiliereNom}
'''
            : '''
Désolé, votre demande de réorientation a été refusée.
Motif : $commentaire
''',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('⚠️ Notification non envoyée: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification de traitement : ${e.message}');
      if (e.response != null) {
        print('Détails de l\'erreur: ${e.response?.data}');
      }
    } catch (e) {
      print('❌ Erreur inattendue lors de l\'envoi de la notification : $e');
    }
  }

  void _logError(DioException error) {
    print('Erreur lors de la requête : ${error.message}');
  }

  Future<String> _getAuthToken() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        print('⚠️ Token non trouvé dans le stockage sécurisé');
        return '';
      }
      return token;
    } catch (e) {
      print("Erreur lors de la récupération du token : $e");
      return '';
    }
  }

  Future<int> _getIdEtudiantConnecte() async {
    try {
      final box = GetStorage();
      final userData = box.read('user');
      
      if (userData != null && userData['id'] != null) {
        return userData['id'];
      }
      
      return 0;
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID utilisateur: $e');
      return 0;
    }
  }
  
  Future<String> _getUserRole() async {
    try {
      final box = GetStorage();
      final userData = box.read('user');
      
      if (userData != null && userData['role'] != null) {
        return userData['role'];
      }
      
      return 'etudiant'; // Rôle par défaut
    } catch (e) {
      print('Erreur lors de la récupération du rôle utilisateur: $e');
      return 'etudiant';
    }
  }

  void _handleError(DioException error) {
    print('Erreur Dio détaillée:');
    print('Type: ${error.type}');
    print('Message: ${error.message}');
    print('URL: ${error.requestOptions.uri}');
    print('Méthode: ${error.requestOptions.method}');
    print('Headers: ${error.requestOptions.headers}');
    print('Data: ${error.requestOptions.data}');
    
    if (error.response != null) {
      print('Status code: ${error.response?.statusCode}');
      print('Réponse d\'erreur: ${error.response?.data}');
      
      switch (error.response?.statusCode) {
        case 400:
          throw Exception('Données invalides. Veuillez vérifier les informations saisies.');
        case 401:
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        case 403:
          throw Exception('Accès non autorisé.');
        case 404:
          throw Exception('Service non trouvé.');
        case 413:
          throw Exception('Le fichier est trop volumineux.');
        case 415:
          throw Exception('Type de fichier non supporté.');
        case 500:
          throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
        default:
          throw Exception('Une erreur est survenue. Veuillez réessayer.');
      }
    } else {
      print('Aucune réponse du serveur');
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    }
  }
}
