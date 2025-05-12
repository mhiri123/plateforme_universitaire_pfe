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
      if (instance.faculty case final value?) 'faculty': value,
      if (instance.filiere case final value?) 'filiere': value,
      'niveau': instance.niveau,
      if (instance.niveauLibelle case final value?) 'niveau_libelle': value,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      if (instance.token case final value?) 'token': value,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      status: json['status'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user': instance.user.toJson(),
      if (instance.token case final value?) 'token': value,
      if (instance.message case final value?) 'message': value,
    };
