import 'package:flutter/material.dart';

class AdminHomeController {
  final BuildContext context;

  AdminHomeController(this.context);

  // Gérer les facultés
  void navigateToFaculties() {
    Navigator.pushNamed(context, "/admin_faculties");
  }

  // Gérer les demandes
  void navigateToRequests() {
    Navigator.pushNamed(context, "/admin_requests");
  }

  // Gérer les utilisateurs
  void navigateToUsers() {
    Navigator.pushNamed(context, "/admin_users");
  }

  // Voir les notifications
  void navigateToNotifications() {
    Navigator.pushNamed(context, "/notifications");
  }

  // Déconnexion et retour à l'écran de connexion
  void logout() {
    Navigator.pushReplacementNamed(context, "/login");
  }


  Widget manageFaculties() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Faculties"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text("Manage Faculties Screen"),
      ),
    );
  }
}
