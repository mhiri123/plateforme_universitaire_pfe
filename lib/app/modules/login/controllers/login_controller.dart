import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demande/controllers/demande_controller.dart';
import '../../home/controllers/notification_controller.dart';
import '../../homeadmin/views/homeadmin_view.dart';
import '../../homestudent/views/homestudent_view.dart';
import '../../hometeacher/views/hometeacher_view.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final demandeController = Get.put(DemandeController());
    final chatController = Get.put(ChatController());
    final notificationController = Get.put(NotificationController());

    if (email == 'student@example.com' && password == 'password123') {
      Get.off(() => StudentHomeScreen(
        demandeReoController: demandeController,
        demandeTransfertController: demandeController,
        chatController: chatController,
        notificationController: notificationController,
      ));
    } else if (email == 'teacher@example.com' && password == 'password123') {
      Get.off(() => TeacherHomeScreen(
        demandeController: demandeController,
        chatController: chatController,
        notificationController: notificationController,
      ));
    } else if (email == 'admin@example.com' && password == 'password123') {
      Get.off(() => AdminHomeScreen(
        demandeController: demandeController,
        chatController: chatController,
        notificationController: notificationController,
      ));
    } else {
      Get.snackbar("Erreur", "Email ou mot de passe incorrect",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
