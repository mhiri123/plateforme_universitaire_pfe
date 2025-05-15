import 'package:get/get.dart';
import '../controllers/traiterdemande_reo_controller.dart';
import '../../../services/demande_reorientation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TraiterdemandeReoBinding extends Bindings {
  @override
  void dependencies() {
    print('Initialisation du binding de traitement des demandes');

    // Initialiser le stockage sécurisé
    Get.lazyPut<FlutterSecureStorage>(() => const FlutterSecureStorage());

    // Initialiser Dio avec l'URL de base
    final dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.17:8000/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ));

    // Ajouter les intercepteurs pour le logging
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Injecter Dio
    Get.lazyPut<Dio>(() => dio);

    // Injecter le service
    Get.lazyPut<DemandeReorientationService>(
      () => DemandeReorientationService(Get.find<Dio>()),
    );

    // Injecter le contrôleur
    Get.lazyPut<TraiterdemandeReoController>(
      () => TraiterdemandeReoController(),
    );

    print('Binding de traitement des demandes initialisé avec succès');
  }
}
