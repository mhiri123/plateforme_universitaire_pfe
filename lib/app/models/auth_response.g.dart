// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      faculty: json['faculty'] as String?,
      filiere: json['filiere'] as String?,
      niveau: json['niveau'] == null ? 1 : _parseNiveau(json['niveau']),
      niveauLibelle: json['niveau_libelle'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'email': instance.email,
      'role': instance.role,
      'faculty': instance.faculty,
      'filiere': instance.filiere,
      'niveau': instance.niveau,
      'niveau_libelle': instance.niveauLibelle,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'token': instance.token,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      message: json['message'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user.toJson(),
      'token': instance.token,
    };
