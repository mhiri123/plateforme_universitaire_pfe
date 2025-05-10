import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/notification.dart';
import '../../envoyer_notification/controllers/notification_sender_controller.dart';

class EnvoyerNotificationScreen extends StatelessWidget {
  final NotificationSenderController notificationController = Get.put(NotificationSenderController());
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
                      int.parse(recipientController.text), // Convertir en entier si c'est un ID utilisateur
                      NotificationType.email, // Exemple de type (à ajuster selon vos besoins)
                      "Titre de notification",
                      messageController.text,
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
                    subtitle: Text("À : ${notification.userId} - ${notification.id}"),
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
