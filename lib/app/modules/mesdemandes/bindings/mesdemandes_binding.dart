import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/demande_reorientation_service.dart';
import '../controllers/mesdemandes_controller.dart';

class MesdemandesBinding extends Bindings {
  @override
  void dependencies() {
    print('Initialisation du binding Mesdemandes...');

    // Initialiser le stockage sécurisé
    final secureStorage = const FlutterSecureStorage();
    Get.put<FlutterSecureStorage>(secureStorage, permanent: true);

    // Initialiser Dio avec l'URL de base
    final dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.17:8000/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ));

    // Ajouter les intercepteurs pour le logging
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Injecter Dio de manière permanente
    Get.put<Dio>(dio, permanent: true);

    // Créer et injecter le service de manière permanente
    final service = DemandeReorientationService(
      dio: Get.find<Dio>(),
      secureStorage: Get.find<FlutterSecureStorage>(),
    );
    Get.put<DemandeReorientationService>(service, permanent: true);

    // Injecter le contrôleur
    Get.put<MesdemandesController>(MesdemandesController());

    print('Binding Mesdemandes initialisé avec succès');
  }
} 