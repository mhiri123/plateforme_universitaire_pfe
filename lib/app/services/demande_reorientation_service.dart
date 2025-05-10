import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import '../models/demande_reorientation_model.dart';

part 'demande_reorientation_service.g.dart';

@RestApi(baseUrl: "https://192.168.1.17:8000/api")
abstract class DemandeReorientationApiService {
  factory DemandeReorientationApiService(Dio dio, {String? baseUrl}) =
  _DemandeReorientationApiService;

  @POST("/reorientation/demande-reorientation")
  Future<DemandeReorientation> soumettreDemande(@Body() FormData formData);

  @GET("/reorientation/demandes/en-attente")
  Future<List<DemandeReorientation>> listerDemandesEnAttente();

  @GET("/demandes/etudiant/{idEtudiant}")
  Future<List<DemandeReorientation>> listerDemandesEtudiant(
      @Path("idEtudiant") int idEtudiant);

  @PUT("/demandes/{id}/traiter")
  Future<DemandeReorientation> traiterDemande(
      @Path("id") int id, @Body() Map<String, dynamic> donneesTraitement);
}

class DemandeReorientationService {
  final DemandeReorientationApiService _apiService;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: "https://192.168.1.17:8000/api",
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
    final token = await _getAuthToken();
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    handler.next(options);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    _logError(error);
    handler.next(error);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
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
    _validateDonnees(
      nom: nom,
      prenom: prenom,
      filiereActuelleNom: filiereActuelleNom,
      nouvelleFiliereNom: nouvelleFiliereNom,
      motivation: motivation,
      level: level,
      facultyName: facultyName,
    );

    try {
      final formData = FormData.fromMap({
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'filiere_actuelle_nom': filiereActuelleNom,
        'nouvelle_filiere_nom': nouvelleFiliereNom,
        'motivation': motivation.trim(),
        'level': level,
        'faculty_name': facultyName,
        'date_creation': DateTime.now().toIso8601String(),
        'statut': StatutDemande.enAttente.name,
        if (pieceJustificative != null)
          'piece_justificative': await MultipartFile.fromFile(
            pieceJustificative.path,
            filename: pieceJustificative.path.split('/').last,
          ),
      });

      final response = await _apiService.soumettreDemande(formData);
      await _envoyerNotificationCreation(response);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<List<DemandeReorientation>> listerDemandesEnAttente() async {
    try {
      return await _apiService.listerDemandesEnAttente();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<List<DemandeReorientation>> listerMesDemandesReorientation() async {
    try {
      final idEtudiant = await _getIdEtudiantConnecte();
      return await _apiService.listerDemandesEtudiant(idEtudiant);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<DemandeReorientation> traiterDemande({
    required DemandeReorientation demande,
    required bool isAccepted,
    String? commentaire,
  }) async {
    try {
      final donneesTraitement = {
        'statut': isAccepted
            ? StatutDemande.acceptee.name.toUpperCase()
            : StatutDemande.rejetee.name.toUpperCase(),
        'commentaire_admin': commentaire ?? '',
        'date_traitement': DateTime.now().toIso8601String(),
      };

      final result = await _apiService.traiterDemande(
        demande.id!,
        donneesTraitement,
      );

      await _envoyerNotificationTraitement(
        demande: result,
        isAccepted: isAccepted,
        commentaire: commentaire,
      );

      return result;
    } on DioException catch (e) {
      _handleError(e);
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

    // Ajoutez ici vos règles de validation si besoin

    if (validationErrors.isNotEmpty) {
      throw ArgumentError(validationErrors.join('\n'));
    }
  }

  Future<void> _envoyerNotificationCreation(DemandeReorientation demande) async {
    try {
      await _dio.post('/notifications', data: {
        'type': 'DEMANDE_REORIENTATION_CREATION',
        'destinataire': {
          'nom': demande.nom,
          'prenom': demande.prenom,
        },
        'titre': 'Nouvelle Demande de Réorientation',
        'message': '''
Votre demande de réorientation a été enregistrée.
Filière actuelle : ${demande.filiereActuelleNom}
Nouvelle filière : ${demande.nouvelleFiliereNom}
Statut : En attente de traitement
''',
      });
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification de création : $e');
    }
  }

  Future<void> _envoyerNotificationTraitement({
    required DemandeReorientation demande,
    required bool isAccepted,
    String? commentaire,
  }) async {
    try {
      await _dio.post('/notifications', data: {
        'type': 'DEMANDE_REORIENTATION_TRAITEMENT',
        'destinataire': {
          'nom': demande.nom,
          'prenom': demande.prenom,
        },
        'titre': isAccepted
            ? 'Demande de Réorientation Acceptée'
            : 'Demande de Réorientation Rejetée',
        'message': isAccepted
            ? '''
Félicitations, votre demande de réorientation a été acceptée.
Filière : ${demande.nouvelleFiliereNom}
'''
            : '''
Désolé, votre demande de réorientation a été rejetée.
Motif : $commentaire
''',
      });
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification de traitement : $e');
    }
  }

  void _logError(DioException error) {
    print('Erreur lors de la requête : ${error.message}');
  }

  Future<String> _getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token') ?? '';
  }

  Future<int> _getIdEtudiantConnecte() async {
    final id = await _secureStorage.read(key: 'id_etudiant');
    return int.tryParse(id ?? '0') ?? 0;
  }

  void _handleError(DioException error) {
    print('DioError: ${error.message}');
    if (error.response != null) {
      print('DioError Response: ${error.response?.data}');
    } else {
      print('DioError: No response data available');
    }
  }
}
