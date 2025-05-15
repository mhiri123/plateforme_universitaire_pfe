import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_response.dart';
import '../models/reference_models.dart';
import '../models/api_list_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://172.23.0.1:8000/api")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl = "http://172.23.0.1:8000/api"}) {
    // Ajout des logs pour debug
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
        onError: (DioError e, handler) {
          print('❌ [ERROR]');
          print('❗ Message: ${e.message}');
          print('❗ URL: ${e.requestOptions.uri}');
          print('❗ Response: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );

    return _ApiService(dio, baseUrl: baseUrl);
  }

  @POST("/login")
  Future<AuthResponse> login(@Body() Map<String, dynamic> loginData);

  @POST("/register")
  Future<AuthResponse> register(@Body() Map<String, dynamic> registerData);

  @GET("/register/roles")
  Future<ApiListResponse<RoleModel>> getRoles();

  @GET("/register/faculties")
  Future<ApiListResponse<FacultyModel>> getFaculties();

  @GET("/register/filieres")
  Future<ApiListResponse<FiliereModel>> getFilieres({
    @Query('faculty_name') String? facultyName,
  });

  @GET("/register/levels")
  Future<ApiListResponse<LevelModel>> getLevels();

  @POST("/logout")
  Future<void> logout();

  @POST("/password/reset")
  Future<void> resetPassword(@Body() Map<String, dynamic> resetData);

  @POST("/password/email")
  Future<void> sendPasswordResetLink(@Body() Map<String, dynamic> emailData);
}

// Ancienne classe ApiService renommée pour éviter le conflit avec Retrofit
class ApiServiceHelper {
  late final Dio _dio;
  final String _baseUrl;

  ApiServiceHelper({String? baseUrl})
      : _baseUrl = baseUrl ?? 'http://172.23.0.1:8000/api' {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 15),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('📤 [REQUEST]');
            print(
                '➡️ \\${options.method} \\${options.baseUrl}\\${options.path}');
            print('➡️ Headers: \\${options.headers}');
            print('➡️ Data: \\${options.data}');
            print('➡️ Query: \\${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ [RESPONSE]');
            print('⬅️ Status Code: \\${response.statusCode}');
            print('⬅️ Data: \\${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          if (kDebugMode) {
            print('❌ [ERROR]');
            print('❗ Message: \\${e.message}');
            print('❗ URL: \\${e.requestOptions.uri}');
            print('❗ Response: \\${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );

    _dio.interceptors.add(RetryInterceptor());
  }

  // Method to set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<dynamic> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.post(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<dynamic> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.put(path, data: data, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<dynamic> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Erreur HTTP ${response.statusCode}',
      );
    }
  }

  void _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Délai de connexion dépassé. Veuillez réessayer.');

        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            throw Exception('Non autorisé. Veuillez vous reconnecter.');
          } else if (error.response?.statusCode == 403) {
            throw Exception(
                'Accès interdit. Vous n\'avez pas les permissions requises.');
          } else if (error.response?.statusCode == 404) {
            throw Exception('Ressource introuvable.');
          } else if (error.response?.statusCode == 500) {
            throw Exception(
                'Erreur serveur interne. Veuillez réessayer plus tard.');
          } else {
            throw Exception(
                'Erreur ${error.response?.statusCode ?? "inconnue"}');
          }

        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            throw Exception(
                'Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
          }
          throw Exception('Erreur inconnue: ${error.message}');

        default:
          throw Exception('Erreur: ${error.message}');
      }
    } else {
      throw Exception('Erreur inattendue: $error');
    }
  }
}

// A custom retry interceptor for Dio
class RetryInterceptor extends Interceptor {
  int maxRetries = 3;
  int retries = 0;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on network issues or timeout
    if (retries < maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.unknown)) {
      retries++;

      if (kDebugMode) {
        print('🔄 Tentative de reconnexion ${retries}/${maxRetries}');
      }

      // Exponential backoff delay (1s, 2s, 4s)
      final delay = Duration(seconds: (1 << (retries - 1)));
      await Future.delayed(delay);

      try {
        // Retry the request
        final options = err.requestOptions;
        final dio = Dio();
        final response = await dio.request(
          options.path,
          options: Options(
            method: options.method,
            headers: options.headers,
            contentType: options.contentType,
          ),
          data: options.data,
          queryParameters: options.queryParameters,
        );

        return handler.resolve(response);
      } catch (e) {
        // If retry fails
        return super.onError(err, handler);
      }
    }

    // Reset retry count
    retries = 0;

    return super.onError(err, handler);
  }
}
