import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DemandeReorientationService extends GetxService {
  final Dio _dio = Get.find<Dio>();
  
  // Utiliser l'instance Dio injectée
  Future<Map<String, dynamic>> envoyerDemande(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/reorientations', data: data);
      return response.data;
    } catch (e) {
      debugPrint('Erreur lors de l\'envoi de la demande: $e');
      rethrow;
    }
  }
  
  // Autres méthodes du service...
}
