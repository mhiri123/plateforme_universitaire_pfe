import 'package:flutter/material.dart';

class TeacherController {
  final BuildContext context;

  TeacherController(this.context);

  // Gérer les demandes de transfert
  void viewTransferRequests() {
    Navigator.pushNamed(context, "/teacher_transfer_requests");
  }

  // Accéder aux messages
  void openMessages() {
    Navigator.pushNamed(context, "/chat");
  }

  // Voir les notifications
  void viewNotifications() {
    Navigator.pushNamed(context, "/notifications");
  }

  // Déconnexion et retour à l'écran de connexion
  void logout() {
    Navigator.pushReplacementNamed(context, "/login");
  }
}
