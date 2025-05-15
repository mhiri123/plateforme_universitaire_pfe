import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class Notification {
  final int? id;
  final String type;
  @JsonKey(name: 'user_id')
  final int? destinataireId; // Nullable field mapped to user_id
  final String titre;
  final String message;
  @JsonKey(
      name: 'is_read', defaultValue: false) // Ajout d'une valeur par défaut
  final bool isRead;
  @JsonKey(
      name: 'read_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? readAt; // Nullable field with custom converters
  @JsonKey(name: 'related_id')
  final int? relatedId; // Nullable field
  @JsonKey(name: 'related_type')
  final String? relatedType; // Nullable field
  @JsonKey(
      name: 'created_at',
      fromJson: _nonNullableDateTimeFromJson,
      toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(
      name: 'updated_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt; // Nullable field with custom converters

  Notification({
    this.id,
    required this.type,
    this.destinataireId, // Optional parameter
    required this.titre,
    required this.message,
    required this.isRead,
    this.readAt,
    this.relatedId,
    this.relatedType,
    required this.createdAt,
    this.updatedAt,
  });

  // Custom converters for DateTime fields to handle null values
  static DateTime? _dateTimeFromJson(String? dateString) {
    return dateString == null ? null : DateTime.tryParse(dateString);
  }

  // Non-nullable converter for DateTime fields
  static DateTime _nonNullableDateTimeFromJson(String dateString) {
    return DateTime.parse(dateString);
  }

  static String? _dateTimeToJson(DateTime? date) {
    return date?.toIso8601String();
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    // Vérification pour s'assurer que isRead a une valeur booléenne
    if (!json.containsKey('is_read') || json['is_read'] == null) {
      json['is_read'] = false; // Valeur par défaut
    }
    return _$NotificationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification copyWith({
    int? id,
    String? type,
    int? destinataireId,
    String? titre,
    String? message,
    bool? isRead,
    DateTime? readAt,
    int? relatedId,
    String? relatedType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      destinataireId: destinataireId ?? this.destinataireId,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      relatedId: relatedId ?? this.relatedId,
      relatedType: relatedType ?? this.relatedType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
