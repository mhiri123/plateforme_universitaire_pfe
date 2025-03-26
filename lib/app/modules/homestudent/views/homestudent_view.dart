import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/views/demandereo_view.dart';
import '../../demandetransfert/views/demandetransfert_view.dart';
import '../../notification/controllers/notification_controller.dart';


class StudentHomeScreen extends StatelessWidget {
  final ChatController chatController = Get.find();
  final NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil Étudiant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Faire une demande de réorientation'),
              leading: Icon(Icons.school),
              onTap: () {
                Get.to(() => DemandeReorientationScreen());
              },
            ),
            ListTile(
              title: Text('Faire une demande de transfert'),
              leading: Icon(Icons.transfer_within_a_station),
              onTap: () {
                Get.to(() => DemandeTransfertScreen());
              },
            ),
            Divider(),
            ListTile(
              title: Text('Chat'),
              leading: Icon(Icons.chat),
              onTap: () {
                // Navigation vers l'écran de chat
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Navigation vers l'écran de notifications
              },
            ),
          ],
        ),
      ),
    );
  }
}
