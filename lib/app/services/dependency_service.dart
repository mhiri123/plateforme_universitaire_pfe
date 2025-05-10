import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:plateforme_universitaire/app/services/api_service.dart';

class DependencyService {
  static void init() {
    // Initialiser Dio avec les options et intercepteurs
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    // Configurer les intercepteurs pour les logs
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = Get.find<FlutterSecureStorage>();
        final token = await storage.read(key: 'auth_token');
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        print('📤 [REQUEST]');
        print('➡️ ${options.method} ${options.baseUrl}${options.path}');
        print('➡️ Headers: ${options.headers}');
        print('➡️ Data: ${options.data}');
        print('➡️ Query: ${options.queryParameters}');
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [RESPONSE]');
        print('⬅️ Status Code: ${response.statusCode}');
        print('⬅️ Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ [ERROR]');
        print('❗ Message: ${e.message}');
        print('❗ URL: ${e.requestOptions.uri}');
        print('❗ Response: ${e.response?.data}');
        return handler.next(e);
      },
    ));
    
    // Enregistrer les dépendances dans GetX
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage());
    Get.put<Dio>(dio);
    Get.put<ApiService>(ApiService(dio));
  }
}
