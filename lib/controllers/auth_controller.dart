import 'package:get/get.dart';
import '../app/models/auth_response.dart';

class AuthController extends GetxController {
  // Utilisateur connecté
  final Rxn<User> currentUser = Rxn<User>();

  void login(User user) {
    currentUser.value = user;
  }

  void logout() {
    currentUser.value = null;
  }

  // Accesseurs
  String get prenom => currentUser.value?.prenom ?? '';
  String get nom => currentUser.value?.nom ?? '';
  String get fullName => currentUser.value?.fullName ?? '';
  String get email => currentUser.value?.email ?? '';
  String get role => currentUser.value?.role ?? '';
  String get filiere => currentUser.value?.filiere ?? '';
  String get faculte => currentUser.value?.faculty ?? '';

  // Libellé du niveau déjà fourni dans le modèle
  String get niveau => currentUser.value?.displayNiveauLibelle ?? '';
}
