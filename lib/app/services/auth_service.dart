import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const String _baseUrl = 'http://192.168.1.17:8000/api';

  AuthService({
    required Dio dio,
    required FlutterSecureStorage storage,
  })  : _dio = dio,
        _storage = storage {
    _dio.options.baseUrl = _baseUrl;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      // Stocker le token JWT
      final token = response.data['access_token'];
      await _storage.write(key: 'jwt_token', value: token);

      return response.data;
    } catch (e) {
      print('❌ Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/logout');
      await _storage.delete(key: 'jwt_token');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
} 