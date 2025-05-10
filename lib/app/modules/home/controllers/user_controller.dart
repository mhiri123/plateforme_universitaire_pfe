import 'package:get/get.dart';
import '../../../models/auth_response.dart';
import '../../../services/permission_service.dart';
import '../../../services/user_service.dart';
import '../../../models/permission.dart';

class UserController extends GetxController {
  final userService = UserService(Get.find()); // Utilisation de Dio injecté via Get.put()

  var userEmail = "".obs;
  var userRole = "".obs;
  var permissions = <Permission>[].obs;
  final Rx<User?> utilisateurConnecte = Rx<User?>(null);

  /// Définir l'utilisateur et charger ses permissions + infos complètes
  Future<void> setUser(String email, String role, int userId) async {
    userEmail.value = email;
    userRole.value = role;

    try {
      // Charger les permissions de l'utilisateur
      List<Permission> userPermissions = await PermissionService.getUserPermissions(userId);
      permissions.assignAll(userPermissions);

      // Charger les détails de l'utilisateur
      User user = await userService.getUserById(userId);
      utilisateurConnecte.value = user;
    } catch (e) {
      print("Erreur lors du chargement des permissions ou de l'utilisateur: $e");
    }
  }

  // Méthodes pour récupérer les informations de l'utilisateur connecté
  String getNom() {
    return utilisateurConnecte.value?.nom ?? '';
  }

  String getPrenom() {
    return utilisateurConnecte.value?.prenom ?? '';
  }

  String getFiliere() {
    return utilisateurConnecte.value?.filiere ?? '';
  }

  String getFaculte() {
    return utilisateurConnecte.value?.faculty ?? '';
  }

  // Nouvelle méthode pour récupérer le niveau et son libellé
  int getNiveau() {
    return utilisateurConnecte.value?.niveau ?? 1;
  }

  String getNiveauLibelle() {
    return utilisateurConnecte.value?.displayNiveauLibelle ?? 'Non défini';
  }

  // Cette méthode retourne les détails de l'utilisateur sous forme de Map
  Map<String, String> getUserDetails() {
    return {
      'nom': getNom(),
      'prenom': getPrenom(),
      'filiere': getFiliere(),
      'faculté': getFaculte(),
      'niveau': getNiveauLibelle(),
    };
  }

  // Vérifier si l'utilisateur a une permission spécifique
  bool hasPermission(String permissionName) {
    return permissions.any((perm) => perm.name == permissionName);
  }

  // Déconnexion de l'utilisateur
  void logout() {
    userEmail.value = "";
    userRole.value = "";
    permissions.clear();
    utilisateurConnecte.value = null;
    Get.offAllNamed("/login");
  }
}
