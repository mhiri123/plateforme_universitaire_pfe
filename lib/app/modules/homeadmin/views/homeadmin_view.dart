import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../traiterdemande/views/traiterdemande_view.dart';
 // Suppose que vous avez déjà un écran pour traiter les demandes

class AdminHomeScreen extends StatelessWidget {
  final DemandeReorientationController demandeReorientationController = Get.find();
  final DemandeTransfertController demandeTransfertController = Get.find();
  final ChatController chatController = Get.find();
  final NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page d'accueil Admin")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Gérer les demandes de réorientation'),
              leading: Icon(Icons.assignment),
              onTap: () {
                // Navigation vers l'écran de gestion des demandes de réorientation
                Get.to(() => TraiterDemandeScreen(demandeType: 'Réorientation'));
              },
            ),
            ListTile(
              title: Text('Gérer les demandes de transfert'),
              leading: Icon(Icons.transfer_within_a_station),
              onTap: () {
                // Navigation vers l'écran de gestion des demandes de transfert
                Get.to(() => TraiterDemandeScreen(demandeType: 'Transfert'));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Chat'),
              leading: Icon(Icons.chat),
              onTap: () {
                // L'admin peut accéder au chat
                // Vous pouvez ouvrir une vue de chat ici
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // L'admin peut consulter les notifications
              },
            ),
          ],
        ),
      ),
    );
  }
}
