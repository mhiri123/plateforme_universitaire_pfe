import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification {
  final int? id;
  final int? user_id;
  final String? type;
  final int? destinataireId;
  final String? titre;
  final String? message;
  @JsonKey(name: 'is_read')
  final bool? isRead;
  final String? read_at;
  final int? related_id;
  final String? related_type;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updated_at;

  Notification({
    this.id,
    this.user_id,
    this.type,
    this.destinataireId,
    this.titre,
    this.message,
    this.isRead,
    this.read_at,
    this.related_id,
    this.related_type,
    this.createdAt,
    this.updated_at,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification copyWith({
    int? id,
    int? user_id,
    String? type,
    int? destinataireId,
    String? titre,
    String? message,
    bool? isRead,
    String? read_at,
    int? related_id,
    String? related_type,
    DateTime? createdAt,
    DateTime? updated_at,
  }) {
    return Notification(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      type: type ?? this.type,
      destinataireId: destinataireId ?? this.destinataireId,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      read_at: read_at ?? this.read_at,
      related_id: related_id ?? this.related_id,
      related_type: related_type ?? this.related_type,
      createdAt: createdAt ?? this.createdAt,
      updated_at: updated_at ?? this.updated_at,
    );
  }
} 