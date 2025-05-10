import 'dart:io';
import 'package:dio/dio.dart';
import '../models/demande_transfert_etudiant_model.dart';


class DemandeTransfertEtudiantService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://votre-api.com/api/transfert/etudiant/',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));

  Future<DemandeTransfertEtudiant> soumettreDemandeTransfert(
      DemandeTransfertEtudiant demande,
      File? document
      ) async {
    try {
      FormData formData = FormData.fromMap({
        'demande': demande.toJson(),
        'document': document != null
            ? await MultipartFile.fromFile(document.path)
            : null,
      });

      final response = await _dio.post('soumettre', data: formData);
      return DemandeTransfertEtudiant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<DemandeTransfertEtudiant>> listerDemandesEtudiant(String email) async {
    try {
      final response = await _dio.get('liste/$email');
      return (response.data as List)
          .map((item) => DemandeTransfertEtudiant.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DemandeTransfertEtudiant> consulterStatutDemande(int demandeId) async {
    try {
      final response = await _dio.get('statut/$demandeId');
      return DemandeTransfertEtudiant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DemandeTransfertEtudiant> annulerDemande(int demandeId) async {
    try {
      final response = await _dio.put('annuler/$demandeId');
      return DemandeTransfertEtudiant.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw 'Délai de connexion dépassé';
      case DioExceptionType.receiveTimeout:
        throw 'Délai de réception dépassé';
      case DioExceptionType.badResponse:
        throw error.response?.data['message'] ?? 'Erreur serveur';
      default:
        throw 'Erreur de connexion';
    }
  }
}