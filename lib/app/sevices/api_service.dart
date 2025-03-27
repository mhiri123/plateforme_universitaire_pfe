import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../models/user.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000/api/") // Si ton serveur tourne sur le port 8000
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("login")
  Future<User> login(@Field("email") String email, @Field("password") String password);
}

