// controllers/notification_controller.dart
import 'package:get/get.dart';
import '../../../models/notification.dart';
import '../../../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      var fetchedNotifications = await _service.fetchNotifications();
      notifications.assignAll(fetchedNotifications);
      unreadCount.value = fetchedNotifications.where((n) => !n.isRead).length;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les notifications');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _service.markAsRead(notificationId);
      var notification = notifications.firstWhere((n) => n.id == notificationId);
      notification.isRead = true;
      notifications.refresh();
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de marquer la notification comme lue');
    }
  }
}