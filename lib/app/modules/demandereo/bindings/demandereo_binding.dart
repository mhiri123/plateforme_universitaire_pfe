import 'package:get/get.dart';
import '../controllers/demande_reorientation_controller.dart';
import '../../../services/demande_reorientation_service.dart';
import 'package:dio/dio.dart';

class DemandereoBinding extends Bindings {
  @override
  void dependencies() {
    // Initialiser Dio avec l'URL de base
    final dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.17:8000/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    // Injecter Dio
    Get.lazyPut<Dio>(() => dio);

    // Injecter le service
    Get.lazyPut<DemandeReorientationService>(
      () => DemandeReorientationService(dio: Get.find<Dio>()),
    );

    // Injecter le contrôleur
    Get.lazyPut<DemandeReorientationController>(
      () => DemandeReorientationController(),
    );
  }
}
