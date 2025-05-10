// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_transfert_etudiant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandeTransfertEtudiant _$DemandeTransfertEtudiantFromJson(
        Map<String, dynamic> json) =>
    DemandeTransfertEtudiant(
      id: (json['id'] as num?)?.toInt(),
      nomEtudiant: json['nomEtudiant'] as String,
      prenomEtudiant: json['prenomEtudiant'] as String,
      email: json['email'] as String,
      faculteOrigine: json['faculteOrigine'] as String,
      faculteDestination: json['faculteDestination'] as String,
      filiere: json['filiere'] as String,
      motivation: json['motivation'] as String,
      cheminDocument: json['cheminDocument'] as String?,
      statut: json['statut'] as String? ?? 'EN_ATTENTE',
      dateCreation: json['dateCreation'] == null
          ? null
          : DateTime.parse(json['dateCreation'] as String),
      dateTraitement: json['dateTraitement'] == null
          ? null
          : DateTime.parse(json['dateTraitement'] as String),
      commentaireAdministration: json['commentaireAdministration'] as String?,
    );

Map<String, dynamic> _$DemandeTransfertEtudiantToJson(
        DemandeTransfertEtudiant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomEtudiant': instance.nomEtudiant,
      'prenomEtudiant': instance.prenomEtudiant,
      'email': instance.email,
      'faculteOrigine': instance.faculteOrigine,
      'faculteDestination': instance.faculteDestination,
      'filiere': instance.filiere,
      'motivation': instance.motivation,
      'cheminDocument': instance.cheminDocument,
      'statut': instance.statut,
      'dateCreation': instance.dateCreation?.toIso8601String(),
      'dateTraitement': instance.dateTraitement?.toIso8601String(),
      'commentaireAdministration': instance.commentaireAdministration,
    };
