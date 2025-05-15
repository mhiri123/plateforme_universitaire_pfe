// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String,
      destinataireId: (json['user_id'] as num?)?.toInt(),
      titre: json['titre'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      readAt: Notification._dateTimeFromJson(json['read_at'] as String?),
      relatedId: (json['related_id'] as num?)?.toInt(),
      relatedType: json['related_type'] as String?,
      createdAt: Notification._nonNullableDateTimeFromJson(
          json['created_at'] as String),
      updatedAt: Notification._dateTimeFromJson(json['updated_at'] as String?),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'user_id': instance.destinataireId,
      'titre': instance.titre,
      'message': instance.message,
      'is_read': instance.isRead,
      'read_at': Notification._dateTimeToJson(instance.readAt),
      'related_id': instance.relatedId,
      'related_type': instance.relatedType,
      'created_at': Notification._dateTimeToJson(instance.createdAt),
      'updated_at': Notification._dateTimeToJson(instance.updatedAt),
    };
