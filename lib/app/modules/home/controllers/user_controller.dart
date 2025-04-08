import 'package:get/get.dart';
import '../../../sevices/permission_service.dart';
import '../../../models/permission.dart';

class UserController extends GetxController {
  var userEmail = "".obs;
  var userRole = "".obs;
  var permissions = <Permission>[].obs; // Liste des permissions

  /// Définir l'utilisateur et charger ses permissions
  Future<void> setUser(String email, String role, int userId) async {
    userEmail.value = email;
    userRole.value = role;

    // Charger les permissions depuis l'API
    try {
      List<Permission> userPermissions = await PermissionService.getUserPermissions(userId);
      permissions.assignAll(userPermissions);
    } catch (e) {
      print("Erreur lors du chargement des permissions: $e");
    }
  }

  /// Vérifier si l'utilisateur a une permission spécifique
  bool hasPermission(String permissionName) {
    return permissions.any((perm) => perm.name == permissionName);
  }

  /// Déconnexion de l'utilisateur
  void logout() {
    userEmail.value = "";
    userRole.value = "";
    permissions.clear();
    Get.offAllNamed("/login"); // Redirection vers la page de login
  }
}
