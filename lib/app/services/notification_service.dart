import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import '../models/notification_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Response;

part 'notification_service.g.dart';

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.17:8000/api',
  );
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio, {String? baseUrl}) =
      _NotificationApiService;

  @GET("/notifications")
  Future<Map<String, dynamic>> listerNotifications();

  @GET("/notifications/unread")
  Future<Map<String, dynamic>> listerNotificationsNonLues();

  @PUT("/notifications/{id}/read")
  Future<Map<String, dynamic>> marquerCommeLue(@Path("id") int id);

  @PUT("/notifications/read-all")
  Future<Map<String, dynamic>> marquerToutCommeLues();

  @DELETE("/notifications/{id}")
  Future<Map<String, dynamic>> supprimerNotification(@Path("id") int id);

  @POST("/notifications")
  Future<Map<String, dynamic>> creerNotification(@Body() Map<String, dynamic> notification);
}

class NotificationService {
  final NotificationApiService _apiService;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  );

  NotificationService({
    Dio? dio,
    NotificationApiService? apiService,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ?? Dio(_defaultOptions),
        _apiService = apiService ?? NotificationApiService(dio ?? Dio(_defaultOptions)),
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
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    print('Erreur Dio: ${error.message}');
    print('URL: ${error.requestOptions.uri}');
    print('Méthode: ${error.requestOptions.method}');
    print('Headers: ${error.requestOptions.headers}');
    if (error.response != null) {
      print('Status code: ${error.response?.statusCode}');
      print('Response data: ${error.response?.data}');
    }
    if (error.response?.statusCode == 401) {
      _secureStorage.delete(key: 'auth_token');
      Get.offAllNamed('/login');
    }
    handler.next(error);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Réponse reçue: ${response.statusCode}');
    print('URL: ${response.requestOptions.uri}');
    print('Data: ${response.data}');
    handler.next(response);
  }

  Future<List<Notification>> listerNotifications() async {
    try {
      print('Tentative de récupération des notifications...');
      final response = await _apiService.listerNotifications();
      print('Réponse reçue du serveur: ${response['data']}');
      
      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> notificationsData = response['data'];
        return notificationsData.map((data) => Notification.fromJson(data)).toList();
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de la récupération des notifications:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la récupération des notifications: $e');
      rethrow;
    }
  }

  Future<List<Notification>> listerNotificationsNonLues() async {
    try {
      print('Tentative de récupération des notifications non lues...');
      final response = await _apiService.listerNotificationsNonLues();
      print('Réponse reçue du serveur: ${response['data']}');
      
      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> notificationsData = response['data'];
        return notificationsData.map((data) => Notification.fromJson(data)).toList();
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de la récupération des notifications non lues:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la récupération des notifications non lues: $e');
      rethrow;
    }
  }

  Future<Notification> marquerCommeLue(int id) async {
    try {
      print('Tentative de marquage de la notification $id comme lue...');
      final response = await _apiService.marquerCommeLue(id);
      print('Réponse reçue du serveur: ${response['data']}');
      
      if (response['status'] == 'success' && response['data'] != null) {
        return Notification.fromJson(response['data']);
      }
      
      throw Exception('Réponse invalide du serveur');
    } on DioException catch (e) {
      print('❌ Erreur Dio lors du marquage de la notification:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors du marquage de la notification: $e');
      rethrow;
    }
  }

  Future<void> marquerToutCommeLues() async {
    try {
      print('Tentative de marquer toutes les notifications comme lues');
      final response = await _apiService.marquerToutCommeLues();
      print('Réponse reçue du serveur: ${response['message']}');
      
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Erreur lors du marquage des notifications');
      }
    } on DioException catch (e) {
      print('❌ Erreur Dio lors du marquage de toutes les notifications:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors du marquage de toutes les notifications: $e');
      rethrow;
    }
  }

  Future<void> supprimerNotification(int id) async {
    try {
      print('Tentative de suppression de la notification $id...');
      final response = await _apiService.supprimerNotification(id);
      print('Réponse reçue du serveur: ${response['message']}');
      
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Erreur lors de la suppression de la notification');
      }
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de la suppression de la notification:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la suppression de la notification: $e');
      rethrow;
    }
  }

  Future<Notification> creerNotification({
    required String type,
    required int destinataireId,
    required String titre,
    required String message,
  }) async {
    try {
      print('Tentative de création d\'une notification...');
      final response = await _apiService.creerNotification({
        'type': type,
        'destinataire_id': destinataireId,
        'titre': titre,
        'message': message,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('Réponse reçue du serveur: ${response['data']}');
      
      if (response['status'] == 'success' && response['data'] != null) {
        return Notification.fromJson(response['data']);
      }
      
      throw Exception('Réponse invalide du serveur');
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de la création de la notification:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la création de la notification: $e');
      rethrow;
    }
  }

  void _handleError(DioException error) {
    print('Erreur Dio détaillée:');
    print('Type: ${error.type}');
    print('Message: ${error.message}');
    print('URL: ${error.requestOptions.uri}');
    print('Méthode: ${error.requestOptions.method}');
    print('Headers: ${error.requestOptions.headers}');
    print('Data: ${error.requestOptions.data}');
    
    if (error.response != null) {
      print('Status code: ${error.response?.statusCode}');
      print('Réponse d\'erreur: ${error.response?.data}');
      
      switch (error.response?.statusCode) {
        case 400:
          throw Exception('Données invalides. Veuillez vérifier les informations saisies.');
        case 401:
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        case 403:
          throw Exception('Accès non autorisé.');
        case 404:
          throw Exception('Service non trouvé.');
        case 500:
          throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
        default:
          throw Exception('Une erreur est survenue. Veuillez réessayer.');
      }
    } else {
      print('Aucune réponse du serveur');
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    }
  }
}
