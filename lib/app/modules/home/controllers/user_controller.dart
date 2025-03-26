import 'package:get/get.dart';

class UserController extends GetxController {
  var userEmail = "".obs;
  var userRole = "".obs;

  void setUser(String email, String role) {
    userEmail.value = email;
    userRole.value = role;
  }

  void logout() {
    userEmail.value = "";
    userRole.value = "";
    Get.offAllNamed("/login"); // Redirection vers la page de login
  }
}
