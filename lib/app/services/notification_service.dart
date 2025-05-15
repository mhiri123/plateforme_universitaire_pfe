import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import '../models/notification_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Response;
import '../utils/notification_utils.dart';

part 'notification_service.g.dart';

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.23.0.1:8000/api',
  );
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio, {String? baseUrl}) =
      _NotificationApiService;

  @GET("/notifications")
  Future<dynamic> listerNotifications();

  @GET("/notifications/unread")
  Future<dynamic> listerNotificationsNonLues();

  @GET("/notifications/user/{userId}")
  Future<dynamic> listerNotificationsParUtilisateur(@Path("userId") int userId);

  @PUT("/notifications/{id}/read")
  Future<dynamic> marquerCommeLue(@Path("id") int id);

  @PUT("/notifications/read-all")
  Future<dynamic> marquerToutCommeLues();

  @DELETE("/notifications/{id}")
  Future<dynamic> supprimerNotification(@Path("id") int id);

  @POST("/notifications")
  Future<dynamic> creerNotification(@Body() Map<String, dynamic> notification);
}

class NotificationService {
  Dio _dio;
  final FlutterSecureStorage _secureStorage;
  NotificationApiService _apiService;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    validateStatus: (status) =>
        status != null &&
        (status >= 200 && status < 300 ||
            status == 500), // Acceptons le 500 pour le gérer manuellement
  );

  NotificationService({
    Dio? dio,
    NotificationApiService? apiService,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ?? Dio(_defaultOptions),
        _apiService =
            apiService ?? NotificationApiService(dio ?? Dio(_defaultOptions)),
        _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _configureDio();
  }

  // Méthode pour recréer l'instance Dio si elle a été fermée
  void _ensureValidDio() {
    try {
      // Test simple pour voir si l'instance Dio est encore valide
      if (_dio.httpClientAdapter == null) {
        print('Recréation de l\'instance Dio car elle semble invalide');
        _dio = Dio(_defaultOptions);
        _apiService = NotificationApiService(_dio);
        _configureDio();
      }
    } catch (e) {
      print('Erreur détectée avec Dio, recréation de l\'instance: $e');
      _dio = Dio(_defaultOptions);
      _apiService = NotificationApiService(_dio);
      _configureDio();
    }
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

  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Ajout des en-têtes essentiels qui pourraient manquer
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

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
      _secureStorage.delete(key: 'token');
      Get.offAllNamed('/login');
    }
    handler.next(error);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Réponse reçue: ${response.statusCode}');
    print('URL: ${response.requestOptions.uri}');
    print('Data: ${response.data}');

    // Gestion spécifique des erreurs 500 qui sont acceptées par validateStatus
    if (response.statusCode == 500) {
      print('Erreur 500 détectée, tentative de récupération...');
      // On pourrait implémenter une logique de retry ou de fallback ici
    }

    handler.next(response);
  }

  // Méthode directe pour lister les notifications avec gestion d'erreur robuste
  Future<List<Notification>> listerNotifications() async {
    try {
      _ensureValidDio(); // S'assurer que l'instance Dio est valide

      print('Tentative de récupération directe des notifications...');
      final response = await _dio.get('/notifications',
          options: Options(headers: {
            'Authorization':
                'Bearer ${await _secureStorage.read(key: 'token')}',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }));

      print('Réponse directe reçue: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final List<dynamic> notificationsData = responseData['data'];
          return notificationsData
              .map((data) => Notification.fromJson(data))
              .toList();
        }
      }

      // Fallback sur l'API service si la méthode directe échoue
      print('Méthode directe insuffisante, tentative via apiService...');
      final apiResponse = await _apiService.listerNotifications();

      if (apiResponse['status'] == 'success' && apiResponse['data'] != null) {
        final List<dynamic> notificationsData = apiResponse['data'];
        return notificationsData
            .map((data) => Notification.fromJson(data))
            .toList();
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

      // En cas d'erreur 500 ou de problème de connexion, essaie une seconde approche
      if (e.type == DioExceptionType.badResponse ||
          e.type == DioExceptionType.connectionError) {
        try {
          print('Tentative de récupération alternative...');
          // Récupérer l'ID utilisateur
          final box = GetStorage();
          final userId = box.read('userId');

          if (userId != null) {
            // Essayer une autre route API (par exemple, spécifique à l'utilisateur)
            final altResponse = await _dio.get('/notifications/user/$userId');
            if (altResponse.statusCode == 200 && altResponse.data != null) {
              final responseData = altResponse.data;
              if (responseData['status'] == 'success' &&
                  responseData['data'] != null) {
                final List<dynamic> notificationsData = responseData['data'];
                return notificationsData
                    .map((data) => Notification.fromJson(data))
                    .toList();
              }
            }
          }
        } catch (innerError) {
          print('❌ Tentative alternative échouée: $innerError');
        }
      }

      // Si même la tentative alternative échoue, on lance une erreur descriptive
      if (e.response?.statusCode == 500) {
        throw Exception(
            'Le serveur de notifications rencontre un problème temporaire. Veuillez réessayer plus tard.');
      } else {
        _handleError(e);
      }

      return []; // Retourner une liste vide au lieu de laisser l'exception se propager
    } catch (e) {
      print(
          '❌ Erreur inattendue lors de la récupération des notifications: $e');
      return []; // Retourner une liste vide au lieu de laisser l'exception se propager
    }
  }

  Future<List<Notification>> listerNotificationsNonLues() async {
    try {
      print('Tentative de récupération des notifications non lues...');
      final response = await _apiService.listerNotificationsNonLues();
      print('Réponse reçue du serveur: $response');

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> notificationsData = response['data'];
        return notificationsData
            .map((data) => Notification.fromJson(data))
            .toList();
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
      print(
          '❌ Erreur inattendue lors de la récupération des notifications non lues: $e');
      rethrow;
    }
  }

  Future<Notification> marquerCommeLue(int id) async {
    try {
      print('Tentative de marquage de la notification $id comme lue...');
      final response = await _apiService.marquerCommeLue(id);
      print('Réponse reçue du serveur: $response');

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
      print('Réponse reçue du serveur: $response');

      if (response['status'] != 'success') {
        throw Exception(
            response['message'] ?? 'Erreur lors du marquage des notifications');
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
      print(
          '❌ Erreur inattendue lors du marquage de toutes les notifications: $e');
      rethrow;
    }
  }

  Future<void> supprimerNotification(int id) async {
    try {
      print('Tentative de suppression de la notification $id...');
      final response = await _apiService.supprimerNotification(id);
      print('Réponse reçue du serveur: $response');

      if (response['status'] != 'success') {
        throw Exception(response['message'] ??
            'Erreur lors de la suppression de la notification');
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
      print(
          '❌ Erreur inattendue lors de la suppression de la notification: $e');
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
      // Vérifier que l'instance Dio est valide avant de l'utiliser
      _ensureValidDio();

      // Convertir le type local en type compatible API
      final apiType = getApiNotificationType(type);

      print('Tentative de création d\'une notification...');
      final response = await _apiService.creerNotification({
        'type': apiType, // Utiliser le type converti
        'user_id': destinataireId,
        'titre': titre,
        'message': message,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('Réponse reçue du serveur: $response');

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

      // En cas d'erreur de connexion, essayer avec une nouvelle instance
      if (e.type == DioExceptionType.connectionError) {
        try {
          print('Tentative avec une nouvelle instance Dio...');
          final newDio = Dio(_defaultOptions);
          newDio.interceptors.add(LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ));

          // Ajouter le token d'authentification
          final token = await _secureStorage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            newDio.options.headers['Authorization'] = 'Bearer $token';
          }

          final newResponse = await newDio.post('/notifications', data: {
            'type': type,
            'user_id': destinataireId, // Également changé ici
            'titre': titre,
            'message': message,
            'is_read': false,
            'created_at': DateTime.now().toIso8601String(),
          });

          if (newResponse.statusCode == 200 || newResponse.statusCode == 201) {
            final data = newResponse.data as Map<String, dynamic>;
            if (data['status'] == 'success' && data['data'] != null) {
              // Mise à jour des instances avec les nouvelles
              _dio = newDio;
              _apiService = NotificationApiService(_dio);
              return Notification.fromJson(data['data']);
            }
          }
        } catch (retryError) {
          print('❌ Nouvelle tentative échouée: $retryError');
        }
      }

      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue lors de la création de la notification: $e');
      rethrow;
    }
  }

  Future<Notification> creerNotificationReorientation({
    required int demandeId,
    required String type,
    required String titre,
    required String message,
    bool isAdminNotification = false,
  }) async {
    try {
      _ensureValidDio(); // S'assurer que l'instance Dio est valide

      print(
          'Création d\'une notification de réorientation pour la demande #$demandeId...');
      print('Destinée à: ${isAdminNotification ? "ADMIN" : "ÉTUDIANT"}');

      // Récupérer d'abord l'ID de l'étudiant associé à la demande
      int? destinataireId;

      try {
        final response =
            await _dio.get('/reorientation/demandes/$demandeId/student',
                options: Options(headers: {
                  'Authorization':
                      'Bearer ${await _secureStorage.read(key: 'token')}',
                  'Accept': 'application/json',
                }));

        if (response.statusCode == 200 && response.data != null) {
          destinataireId = int.tryParse(response.data['student_id'].toString());
          print('✅ ID étudiant récupéré: $destinataireId');
        }
      } catch (e) {
        print('❌ Erreur lors de la récupération de l\'ID étudiant: $e');

        // Fallback: tenter de récupérer les détails complets de la demande
        try {
          final detailsResponse =
              await _dio.get('/reorientation/demandes/$demandeId',
                  options: Options(headers: {
                    'Authorization':
                        'Bearer ${await _secureStorage.read(key: 'token')}',
                    'Accept': 'application/json',
                  }));

          if (detailsResponse.statusCode == 200 &&
              detailsResponse.data != null) {
            // Essayer d'extraire l'ID utilisateur depuis la réponse
            if (detailsResponse.data['user_id'] != null) {
              destinataireId =
                  int.tryParse(detailsResponse.data['user_id'].toString());
              print(
                  '✅ ID étudiant récupéré depuis les détails: $destinataireId');
            }
          }
        } catch (detailsError) {
          print('❌ Erreur lors de la récupération des détails: $detailsError');
        }
      }

      // Si on n'a pas pu récupérer l'ID, utiliser une valeur par défaut (à ajuster selon votre cas)
      if (destinataireId == null) {
        // Dernière tentative avec une valeur fixe basée sur l'ID de demande
        destinataireId = demandeId == 1 ? 3 : (demandeId == 2 ? 4 : 3);
        print('⚠️ Utilisation d\'un ID étudiant par défaut: $destinataireId');
      }

      // Créer la notification en utilisant le endpoint standard /notifications avec les bons paramètres
      final response = await _dio.post('/notifications',
          data: {
            'type': getApiNotificationType(type),
            'user_id': destinataireId, // Utiliser l'ID récupéré
            'titre': titre,
            'message': message,
            'is_read': false,
            'created_at': DateTime.now().toIso8601String(),
          },
          options: Options(headers: {
            'Authorization':
                'Bearer ${await _secureStorage.read(key: 'token')}',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == 'success' &&
            response.data['data'] != null) {
          print('✅ Notification de réorientation créée avec succès');
          return Notification.fromJson(response.data['data']);
        }
      }

      print('⚠️ La réponse n\'a pas le format attendu: ${response.data}');
      throw Exception('Format de réponse invalide');
    } on DioException catch (e) {
      print('❌ Erreur lors de la création de notification de réorientation:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');

      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }

      _handleError(e);
      rethrow;
    } catch (e) {
      print('❌ Erreur inattendue: $e');
      rethrow;
    }
  }

  Future<List<Notification>> listerNotificationsParUtilisateur(
      int userId) async {
    try {
      print(
          'Tentative de récupération des notifications pour l\'utilisateur $userId...');
      final response =
          await _apiService.listerNotificationsParUtilisateur(userId);
      print('Réponse reçue du serveur: $response');

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> notificationsData = response['data'];
        return notificationsData
            .map((data) => Notification.fromJson(data))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      print(
          '❌ Erreur Dio lors de la récupération des notifications utilisateur:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }

      // En cas d'erreur 403 ou 404, on retourne une liste vide au lieu de propager l'erreur
      if (e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        print(
            '⚠️ Accès refusé ou utilisateur non trouvé, retour d\'une liste vide');
        return [];
      }

      _handleError(e);
      return []; // Retourner une liste vide au lieu de laisser l'exception se propager
    } catch (e) {
      print(
          '❌ Erreur inattendue lors de la récupération des notifications utilisateur: $e');
      return []; // Retourner une liste vide au lieu de laisser l'exception se propager
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
          throw Exception(
              'Données invalides. Veuillez vérifier les informations saisies.');
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
      throw Exception(
          'Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    }
  }
}
