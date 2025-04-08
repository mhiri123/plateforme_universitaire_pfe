import 'package:get/get.dart';
import '../../../models/permission.dart';


class PermissionController extends GetxController {
  var permissions = <Permission>[].obs; // Liste des permissions observable

  @override
  void onInit() {
    super.onInit();
    _loadPermissions();
  }

  // Charger des permissions fictives (exemple)
  void _loadPermissions() {
    permissions.addAll([
      Permission(id: 1, role: "Admin", access: "Full Access", isActive: true),
      Permission(id: 2, role: "Enseignant", access: "Gestion des étudiants", isActive: true),
      Permission(id: 3, role: "Étudiant", access: "Accès restreint", isActive: false),
    ]);
  }

  // Basculer l'activation d'une permission
  void togglePermission(int id, bool newValue) {
    int index = permissions.indexWhere((p) => p.id == id);
    if (index != -1) {
      permissions[index].isActive.value = newValue;
    }
  }

  // Ajouter une nouvelle permission
  void addPermission(Permission permission) {
    permission.id = permissions.length + 1; // Génération simple d'ID
    permissions.add(permission);
  }

  // Supprimer une permission
  void removePermission(int id) {
    permissions.removeWhere((p) => p.id == id);
  }
}
