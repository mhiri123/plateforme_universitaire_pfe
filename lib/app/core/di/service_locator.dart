import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/api_service.dart';
import '../../modules/home/controllers/user_controller.dart';

class ServiceLocator {
  static void init() {
    // Services de base
    Get.lazyPut(() => const FlutterSecureStorage(), fenix: true);
    
    // Configuration de Dio
    final dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.17:8000/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ));
    Get.lazyPut(() => dio, fenix: true);

    // Services métier
    Get.lazyPut(() => AuthService(
          dio: Get.find<Dio>(),
          storage: Get.find<FlutterSecureStorage>(),
        ));

    Get.lazyPut(() => ApiService(
          Get.find<Dio>(),
        ));

    Get.lazyPut<NotificationService>(
      () => NotificationService(
        dio: Get.find<Dio>(),
        secureStorage: Get.find<FlutterSecureStorage>(),
      ),
      fenix: true,
    );

    // Contrôleurs
    Get.lazyPut(() => UserController(), fenix: true);
  }
} 