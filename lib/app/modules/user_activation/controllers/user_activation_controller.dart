import 'package:get/get.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart';
import 'package:dio/dio.dart';

class UserActivationController extends GetxController {
  final Dio _dio = Dio();
  late final UserService _userService;

  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    _userService = UserService(_dio);
    fetchUsers();
  }

  // Charger les utilisateurs
  Future<void> fetchUsers() async {
    try {
      final fetchedUsers = await _userService.getUsers();
      users.assignAll(fetchedUsers);
      filteredUsers.assignAll(fetchedUsers);
    } catch (e) {
      print("Erreur chargement utilisateurs: $e");
    }
  }

  // Modifier le statut d'un utilisateur
  Future<void> toggleUserStatus(int id, bool isActive) async {
    try {
      await _userService.updateUserStatus(id, {'is_active': isActive ? 1 : 0});
      int index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = users[index].copyWith(isActive: isActive);
        filterUsers(''); // Rafraîchit la liste filtrée après modification
      }
    } catch (e) {
      print("Erreur changement statut: $e");
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      filterUsers(''); // Rafraîchit la liste filtrée après suppression
    } catch (e) {
      print("Erreur suppression utilisateur: $e");
    }
  }

  // Ajouter un utilisateur
  Future<void> addUser(User user) async {
    try {
      final newUser = await _userService.createUser(user);
      users.add(newUser);
      filterUsers(''); // Rafraîchit la liste filtrée après ajout
    } catch (e) {
      print("Erreur ajout utilisateur: $e");
    }
  }

  // Filtrer les utilisateurs selon la recherche
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users); // Afficher tous les utilisateurs si la recherche est vide
    } else {
      filteredUsers.assignAll(
        users.where((u) =>
        u.name.toLowerCase().contains(query.toLowerCase()) ||
            u.email.toLowerCase().contains(query.toLowerCase())
        ),
      );
    }
  }

  // Modifier le statut de tous les utilisateurs
  void toggleAllUsers(bool activate) {
    for (var user in users) {
      toggleUserStatus(user.id, activate);
    }
  }
}
