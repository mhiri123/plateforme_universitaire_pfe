class AppNotification {
  final String title;
  final String message;
  final DateTime timestamp;
  final String recipientRole;

  AppNotification({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.recipientRole,
  });
}
