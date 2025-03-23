import 'package:flutter/material.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demande/controllers/demande_controller.dart';
import '../../home/controllers/notification_controller.dart';


class AdminHomeScreen extends StatelessWidget {
  final DemandeController demandeController;
  final ChatController chatController;
  final NotificationController notificationController;

  AdminHomeScreen({
    required this.demandeController,
    required this.chatController,
    required this.notificationController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil Admin"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_admin.jpg"), // Remplacez par l'image de fond souhaitée
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Gérer les demandes de réorientation et de transfert",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran pour gérer les demandes
              },
            ),
            ListTile(
              title: Text(
                "Envoyer une notification",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran pour envoyer une notification
              },
            ),
            ListTile(
              title: Text(
                "Voir les statistiques",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran des statistiques
              },
            ),
            ListTile(
              title: Text(
                "Accéder au chat",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran de chat
              },
            ),
          ],
        ),
      ),
    );
  }
}
