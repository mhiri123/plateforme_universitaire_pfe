import 'package:get/get.dart';
import '../../../models/user.dart';
import 'package:dio/dio.dart';

import '../../../services/user_service.dart';


class UserManagementController extends GetxController {
  final Dio _dio = Dio();
  late final UserService _userService;

  var users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    _userService = UserService(_dio);
    fetchUsers();
  }

  // Charger les utilisateurs depuis l'API
  Future<void> fetchUsers() async {
    try {
      final fetchedUsers = await _userService.getUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      print("Erreur chargement utilisateurs: $e");
    }
  }

  // Récupérer un utilisateur par son ID
  User? getUserById(int id) {
    return users.firstWhereOrNull((user) => user.id == id);
  }

  // Modifier un utilisateur
  Future<void> updateUser(User updatedUser) async {
    try {
      await _userService.updateUser(updatedUser.id, updatedUser);
      int index = users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;
      }
    } catch (e) {
      print("Erreur modification utilisateur: $e");
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      users.removeWhere((user) => user.id == id);
    } catch (e) {
      print("Erreur suppression utilisateur: $e");
    }
  }
}
