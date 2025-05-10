// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_transfert_enseignant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandeTransfertEnseignant _$DemandeTransfertEnseignantFromJson(
        Map<String, dynamic> json) =>
    DemandeTransfertEnseignant(
      id: (json['id'] as num?)?.toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      universiteActuelle: json['universiteActuelle'] as String,
      faculteActuelle: json['faculteActuelle'] as String,
      universiteDemandee: json['universiteDemandee'] as String,
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

Map<String, dynamic> _$DemandeTransfertEnseignantToJson(
        DemandeTransfertEnseignant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'email': instance.email,
      'universiteActuelle': instance.universiteActuelle,
      'faculteActuelle': instance.faculteActuelle,
      'universiteDemandee': instance.universiteDemandee,
      'motivation': instance.motivation,
      'cheminDocument': instance.cheminDocument,
      'statut': instance.statut,
      'dateCreation': instance.dateCreation?.toIso8601String(),
      'dateTraitement': instance.dateTraitement?.toIso8601String(),
      'commentaireAdministration': instance.commentaireAdministration,
    };
