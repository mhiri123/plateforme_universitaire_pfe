import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandetransfert/views/demandetransfert_view.dart';
import '../../notification/controllers/notification_controller.dart';


class TeacherHomeScreen extends StatelessWidget {
  final ChatController chatController = Get.find();
  final NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil Enseignant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
