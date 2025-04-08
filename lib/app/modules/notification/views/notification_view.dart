import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Obx(() {
        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            var notif = notificationController.notifications[index];
            return ListTile(
              title: Text(notif.titre), // Accéder à la propriété 'titre'
              subtitle: Text(notif.message), // Accéder à la propriété 'message'
              trailing: Text(
                "${notif.timestamp.hour}:${notif.timestamp.minute}", // Afficher l'heure
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      }),
    );
  }
}
