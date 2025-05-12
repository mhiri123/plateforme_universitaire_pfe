import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../controllers/notification_controller.dart';
import '../../../services/notification_service.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    print('Initialisation des dépendances de notification');
    
    // Initialisation du stockage sécurisé
    final storage = const FlutterSecureStorage();
    Get.put(storage, permanent: true);
    print('✅ Stockage sécurisé initialisé');

    // Configuration de Dio
    final dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.17:8000/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ));

    // Ajout des intercepteurs pour le logging
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    Get.put(dio, permanent: true);
    print('✅ Dio initialisé');

    // Initialisation du service de notification
    final notificationService = NotificationService(
      dio: dio,
      secureStorage: storage,
    );
    Get.put(notificationService, permanent: true);
    print('✅ Service de notification initialisé');

    // Initialisation du contrôleur
    Get.put(NotificationController(notificationService));
    print('✅ Contrôleur de notification initialisé');
  }
}
