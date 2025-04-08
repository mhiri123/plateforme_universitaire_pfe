import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../notification/controllers/notification_controller.dart';

class EnvoyerNotificationScreen extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());
  final TextEditingController messageController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Notifications")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: recipientController,
                  decoration: InputDecoration(labelText: "Destinataire (email ou rôle)"),
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(labelText: "Message"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    notificationController.envoyerNotification(
                      "Titre de notification", // Titre de la notification
                      messageController.text,  // Message
                      recipientController.text, // Destinataire
                    );
                    messageController.clear();
                    recipientController.clear();
                  },
                  child: Text("Envoyer"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  final notification = notificationController.notifications[index];
                  return ListTile(
                    title: Text(notification.message),
                    subtitle: Text("À : ${notification.recipient} - ${notification.id}"),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
