// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_reorientation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandeReorientation _$DemandeReorientationFromJson(
        Map<String, dynamic> json) =>
    DemandeReorientation(
      id: (json['id'] as num?)?.toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      filiereActuelleNom: json['filiere_actuelle_nom'] as String,
      nouvelleFiliereNom: json['nouvelle_filiere_nom'] as String,
      motivation: json['motivation'] as String,
      dateCreation: DemandeReorientation._dateTimeFromJson(
          json['date_creation'] as String?),
      dateTraitement: DemandeReorientation._dateTimeFromJson(
          json['date_traitement'] as String?),
      statut: $enumDecodeNullable(_$StatutDemandeEnumMap, json['status']) ??
          StatutDemande.enAttente,
      commentaireAdmin: json['commentaire_admin'] as String?,
      pieceJustificative: json['piece_justificative'] as String?,
      level: json['level'] as String,
      facultyName: json['facultyName'] as String,
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
      'status': _$StatutDemandeEnumMap[instance.statut]!,
      if (instance.commentaireAdmin case final value?)
        'commentaire_admin': value,
      if (instance.pieceJustificative case final value?)
        'piece_justificative': value,
      'level': instance.level,
      'facultyName': instance.facultyName,
    };

const _$StatutDemandeEnumMap = {
  StatutDemande.enAttente: 'en_attente',
  StatutDemande.acceptee: 'acceptee',
  StatutDemande.rejetee: 'rejetee',
};
