import 'package:dio/dio.dart';
import '../models/user.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // Obtenir tous les utilisateurs
  Future<List<User>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List).map((json) => User.fromJson(json)).toList();
  }

  // Créer un nouvel utilisateur
  Future<User> createUser(User user) async {
    final response = await _dio.post('/users', data: user.toJson());
    return User.fromJson(response.data);
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(int id) async {
    await _dio.delete('/users/$id');
  }

  // Mettre à jour le statut (activation/désactivation)
  Future<void> updateUserStatus(int id, Map<String, dynamic> data) async {
    await _dio.put('/users/$id/status', data: data);
  }

  // ✅ Mettre à jour les infos utilisateur
  Future<void> updateUser(int id, User user) async {
    await _dio.put('/users/$id', data: user.toJson());
  }
}
