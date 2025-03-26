import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../homeadmin/views/homeadmin_view.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../homestudent/views/homestudent_view.dart';
import '../../hometeacher/views/hometeacher_view.dart';



class LoginController extends GetxController {
  final isLoading = false.obs;

  void login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulation de chargement

    // Initialisation des controllers
    Get.put(ChatController());
    Get.put(NotificationController());
    Get.put(DemandeTransfertController());
    Get.put(DemandeReorientationController());

    // Authentification et redirection en fonction du rôle
    if (email == 'admin@example.com' && password == 'password123') {
      Get.offAll(() => AdminHomeScreen());
    } else if (email == 'teacher@example.com' && password == 'password123') {
      Get.offAll(() => TeacherHomeScreen());
    } else if (email == 'student@example.com' && password == 'password123') {
      Get.offAll(() => StudentHomeScreen());
    } else {
      Get.snackbar("Erreur", "Identifiants incorrects",
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }
}
