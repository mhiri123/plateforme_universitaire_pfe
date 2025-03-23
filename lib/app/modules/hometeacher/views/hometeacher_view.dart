import 'package:flutter/material.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demande/controllers/demande_controller.dart';
import '../../home/controllers/notification_controller.dart';

class TeacherHomeScreen extends StatelessWidget {
  final DemandeController demandeController;
  final ChatController chatController;
  final NotificationController notificationController;

  TeacherHomeScreen({
    required this.demandeController,
    required this.chatController,
    required this.notificationController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil Enseignant"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_teacher.jpg"), // Remplacez par l'image de fond souhaitée
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Faire une demande de transfert",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran pour faire une demande de transfert
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
            ListTile(
              title: Text(
                "Voir les notifications",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Naviguer vers l'écran des notifications
              },
            ),
          ],
        ),
      ),
    );
  }
}
