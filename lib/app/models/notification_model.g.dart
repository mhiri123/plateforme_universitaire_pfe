// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String,
      destinataireId: (json['destinataireId'] as num).toInt(),
      titre: json['titre'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'destinataireId': instance.destinataireId,
      'titre': instance.titre,
      'message': instance.message,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };
