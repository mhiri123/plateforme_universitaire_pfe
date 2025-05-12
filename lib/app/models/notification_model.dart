import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class Notification {
  final int? id;
  final String type;
  final int destinataireId;
  final String titre;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  Notification({
    this.id,
    required this.type,
    required this.destinataireId,
    required this.titre,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification copyWith({
    int? id,
    String? type,
    int? destinataireId,
    String? titre,
    String? message,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      destinataireId: destinataireId ?? this.destinataireId,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 