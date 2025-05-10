// models/notification_model.dart
enum NotificationType {
  demandeReorientation,
  statutDemande,
  messageSysteme,
  rappel,
  autre, email
}

class NotificationModel {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String message;
  bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      type: _parseNotificationType(json['type']),
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'demande_reorientation':
        return NotificationType.demandeReorientation;
      case 'statut_demande':
        return NotificationType.statutDemande;
      case 'message_systeme':
        return NotificationType.messageSysteme;
      case 'rappel':
        return NotificationType.rappel;
      default:
        return NotificationType.autre;
    }
  }
}