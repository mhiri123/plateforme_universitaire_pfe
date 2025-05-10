import 'dart:io';
import 'package:dio/dio.dart';
import '../models/demande_transfert_enseignant_model.dart';


class DemandeTransfertEnseignantService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://votre-api.com/api/transfert/enseignant/',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));

  // Soumettre une nouvelle demande de transfert
  Future<DemandeTransfertEnseignant> soumettreDemandeTransfert(
      DemandeTransfertEnseignant demande,
      File? document
      ) async {
    try {
      // Préparation des données pour l'envoi
      FormData formData = FormData.fromMap({
        'demande': demande.toJson(),
        'document': document != null
            ? await MultipartFile.fromFile(document.path,
            filename: document.path.split('/').last)
            : null,
      });

      // Envoi de la demande
      final response = await _dio.post('soumettre', data: formData);
      return DemandeTransfertEnseignant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Lister les demandes pour un enseignant
  Future<List<DemandeTransfertEnseignant>> listerDemandesEnseignant(String email) async {
    try {
      final response = await _dio.get('liste/$email');
      return (response.data as List)
          .map((item) => DemandeTransfertEnseignant.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Consulter le statut d'une demande spécifique
  Future<DemandeTransfertEnseignant> consulterStatutDemande(int demandeId) async {
    try {
      final response = await _dio.get('statut/$demandeId');
      return DemandeTransfertEnseignant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Annuler une demande de transfert
  Future<DemandeTransfertEnseignant> annulerDemande(int demandeId) async {
    try {
      final response = await _dio.put('annuler/$demandeId');
      return DemandeTransfertEnseignant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Gestion centralisée des erreurs
  dynamic _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw 'Délai de connexion dépassé';
      case DioExceptionType.receiveTimeout:
        throw 'Délai de réception dépassé';
      case DioExceptionType.badResponse:
      // Gestion des erreurs spécifiques du serveur
        switch (error.response?.statusCode) {
          case 400:
            throw 'Requête invalide';
          case 401:
            throw 'Non autorisé';
          case 403:
            throw 'Accès interdit';
          case 404:
            throw 'Ressource non trouvée';
          case 500:
            throw 'Erreur serveur interne';
          default:
            throw error.response?.data['message'] ?? 'Erreur serveur';
        }
      case DioExceptionType.cancel:
        throw 'Requête annulée';
      default:
        throw 'Erreur de connexion';
    }
  }
}