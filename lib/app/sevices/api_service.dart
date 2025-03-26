import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user.dart';
import '../models/login_response.dart';  // Créer ce modèle pour gérer la réponse

part 'api_service.g.dart';

@RestApi(baseUrl: "https://example.com/api") // Remplace par ton URL d'API
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/login")
  Future<LoginResponse> login(
      @Field("email") String email,
      @Field("password") String password,
      );

  @GET("/users")
  Future<List<User>> getUsers();
}
