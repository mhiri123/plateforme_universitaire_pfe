// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_reorientation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandeReorientation _$DemandeReorientationFromJson(
        Map<String, dynamic> json) =>
    DemandeReorientation(
      id: DemandeReorientation._parseIdValue(json['id']),
      userId: DemandeReorientation._parseIdValue(json['user_id']),
      adminId: DemandeReorientation._parseIdValue(json['admin_id']),
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      niveau: json['niveau'] as String? ?? '',
      filiereActuelleNom: json['filiere_actuelle_nom'] as String? ?? '',
      nouvelleFiliereNom: json['nouvelle_filiere_nom'] as String? ?? '',
      motivation: json['motivation'] as String? ?? '',
      dateCreation:
          DemandeReorientation._dateTimeFromJson(json['created_at'] as String?),
      dateTraitement: DemandeReorientation._dateTimeFromJson(
          json['date_traitement'] as String?),
      statut: json['status'] == null
          ? StatutDemande.enAttente
          : DemandeReorientation._statutFromJson(json['status']),
      statutFallback: DemandeReorientation._statutFromJson(json['statut']),
      commentaire: json['commentaire'] as String?,
      pieceJustificative: json['piece_justificative'] as String?,
      facultyName: json['faculty_name'] as String? ?? '',
      user: json['user'],
    );

Map<String, dynamic> _$DemandeReorientationToJson(
        DemandeReorientation instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.userId case final value?) 'user_id': value,
      if (instance.adminId case final value?) 'admin_id': value,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'niveau': instance.niveau,
      'filiere_actuelle_nom': instance.filiereActuelleNom,
      'nouvelle_filiere_nom': instance.nouvelleFiliereNom,
      'motivation': instance.motivation,
      'created_at': DemandeReorientation._dateTimeToJson(instance.dateCreation),
      if (DemandeReorientation._dateTimeToJson(instance.dateTraitement)
          case final value?)
        'date_traitement': value,
      'status': DemandeReorientation._statutToJson(instance.statut),
      'statut': DemandeReorientation._statutToJson(instance.statutFallback),
      if (instance.commentaire case final value?) 'commentaire': value,
      if (instance.pieceJustificative case final value?)
        'piece_justificative': value,
      'faculty_name': instance.facultyName,
      if (instance.user case final value?) 'user': value,
    };
