// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      user_id: (json['user_id'] as num?)?.toInt(),
      type: json['type'] as String?,
      destinataireId: (json['destinataireId'] as num?)?.toInt(),
      titre: json['titre'] as String?,
      message: json['message'] as String?,
      isRead: json['is_read'] as bool?,
      read_at: json['read_at'] as String?,
      related_id: (json['related_id'] as num?)?.toInt(),
      related_type: json['related_type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'type': instance.type,
      'destinataireId': instance.destinataireId,
      'titre': instance.titre,
      'message': instance.message,
      'is_read': instance.isRead,
      'read_at': instance.read_at,
      'related_id': instance.related_id,
      'related_type': instance.related_type,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
