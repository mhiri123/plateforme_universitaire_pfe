import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_response.dart';
import '../models/reference_models.dart';
import '../models/api_list_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://192.168.1.17:8000/api")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl = "http://192.168.1.17:8000/api"}) {
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
