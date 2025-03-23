import 'package:plateforme_universitaire/app/models/notification.dart';

class NotificationController {
  List<AppNotification> _notifications = [];

  List<AppNotification> getNotifications(String role) {
    return _notifications.where((notification) => notification.recipientRole == role).toList();
  }

  void addNotification(AppNotification notification) {
    _notifications.add(notification);
  }
}
