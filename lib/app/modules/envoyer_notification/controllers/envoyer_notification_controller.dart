import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/notification.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs; // Liste des notifications
  var nextId = 1.obs; // Compteur pour l'ID unique des notifications

  // Ajouter une notification
  void envoyerNotification(String titre, String message, String recipient) {
    var notification = NotificationModel(
      titre: titre,
      message: message,
      recipient: recipient,
      id: nextId.value,  // Attribuer l'ID à la notification
    );

    // Ajouter la notification à la liste
    notifications.add(notification);

    // Incrémenter l'ID pour la prochaine notification
    nextId.value++;

    // Afficher un snackbar pour informer l'utilisateur de l'envoi de la notification
    Get.snackbar(
      "Notification envoyée",
      "Le message a été transmis.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Récupérer toutes les notifications
  List<NotificationModel> getAllNotifications() {
    return notifications;
  }
}
