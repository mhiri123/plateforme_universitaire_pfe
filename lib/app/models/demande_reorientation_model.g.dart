// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_reorientation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandeReorientation _$DemandeReorientationFromJson(
        Map<String, dynamic> json) =>
    DemandeReorientation(
      id: (json['id'] as num?)?.toInt(),
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      filiereActuelleNom: json['filiere_actuelle_nom'] as String? ?? '',
      nouvelleFiliereNom: json['nouvelle_filiere_nom'] as String? ?? '',
      motivation: json['motivation'] as String? ?? '',
      dateCreation: DemandeReorientation._dateTimeFromJson(
          json['date_creation'] as String?),
      dateTraitement: DemandeReorientation._dateTimeFromJson(
          json['date_traitement'] as String?),
      statut: json['statut'] == null
          ? StatutDemande.enAttente
          : DemandeReorientation._statutFromJson(json['statut'] as String?),
      commentaireAdmin: json['commentaire_admin'] as String?,
      pieceJustificative: json['piece_justificative'] as String?,
      level: json['level'] as String? ?? '',
      facultyName: json['faculty_name'] as String? ?? '',
    );

Map<String, dynamic> _$DemandeReorientationToJson(
        DemandeReorientation instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'filiere_actuelle_nom': instance.filiereActuelleNom,
      'nouvelle_filiere_nom': instance.nouvelleFiliereNom,
      'motivation': instance.motivation,
      'date_creation':
          DemandeReorientation._dateTimeToJson(instance.dateCreation),
      'date_traitement':
          DemandeReorientation._dateTimeToJson(instance.dateTraitement),
      'statut': DemandeReorientation._statutToJson(instance.statut),
      if (instance.commentaireAdmin case final value?)
        'commentaire_admin': value,
      if (instance.pieceJustificative case final value?)
        'piece_justificative': value,
      'level': instance.level,
      'faculty_name': instance.facultyName,
    };
