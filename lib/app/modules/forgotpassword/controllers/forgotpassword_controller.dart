import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  void sendResetLink() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Erreur", "Veuillez entrer votre email",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Simulation d'envoi de l'email (sans backend)
    Get.snackbar("Succès", "Lien de réinitialisation envoyé à $email",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
