// notification_sender_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/notification.dart';

class NotificationSenderController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var nextId = 1.obs;

  void envoyerNotification(int userId, NotificationType type, String title, String message) {
    var notification = NotificationModel(
      id: nextId.value,
      userId: userId,
      type: type,
      title: title,
      message: message,
      createdAt: DateTime.now(),
    );
    notifications.add(notification);
    nextId.value++;

    Get.snackbar(
      "Notification envoyée",
      "Le message a été transmis.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  List<NotificationModel> getAllNotifications() {
    return notifications;
  }
}
