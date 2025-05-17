import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'demande_reorientation_model.g.dart';

@JsonEnum()
enum StatutDemande {
  @JsonValue('en_attente')
  enAttente,
  @JsonValue('acceptee')
  acceptee,
  @JsonValue('rejetee')
  rejetee;

  String get statutTexte {
    switch (this) {
      case StatutDemande.enAttente:
        return 'En attente';
      case StatutDemande.acceptee:
        return 'Acceptée';
      case StatutDemande.rejetee:
        return 'Rejetée';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class DemandeReorientation {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(defaultValue: '')
  final String nom;

  @JsonKey(defaultValue: '')
  final String prenom;

  @JsonKey(name: 'filiere_actuelle_nom', defaultValue: '')
  final String filiereActuelleNom;  // Correspond au nom de la filière actuelle

  @JsonKey(name: 'nouvelle_filiere_nom', defaultValue: '')
  final String nouvelleFiliereNom;  // Correspond au nom de la nouvelle filière

  @JsonKey(defaultValue: '')
  final String motivation;

  @JsonKey(
    name: 'date_creation',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime? dateCreation;

  @JsonKey(
    name: 'date_traitement',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime? dateTraitement;

  @JsonKey(
    name: 'statut',  // Utiliser 'statut' (français) au lieu de 'status' (anglais)
    fromJson: _statutFromJson,
    toJson: _statutToJson,
    defaultValue: StatutDemande.enAttente,
  )
  final StatutDemande statut;

  @JsonKey(name: 'commentaire_admin', includeIfNull: false)
  final String? commentaireAdmin;

  @JsonKey(name: 'piece_justificative', includeIfNull: false)
  final String? pieceJustificative;

  @JsonKey(defaultValue: '')
  final String level; // Niveau d'études
  
  @JsonKey(name: 'faculty_name', defaultValue: '')
  final String facultyName; // Nom de la faculté

  DemandeReorientation({
    this.id,
    required this.nom,
    required this.prenom,
    required this.filiereActuelleNom,
    required this.nouvelleFiliereNom,
    required this.motivation,
    this.dateCreation,
    this.dateTraitement,
    this.statut = StatutDemande.enAttente,
    this.commentaireAdmin,
    this.pieceJustificative,
    required this.level,
    required this.facultyName,
  });

  static StatutDemande _statutFromJson(String? value) {
    switch (value) {
      case 'en_attente':
        return StatutDemande.enAttente;
      case 'acceptee':
        return StatutDemande.acceptee;
      case 'rejetee':
        return StatutDemande.rejetee;
      default:
        return StatutDemande.enAttente;
    }
  }

  static String _statutToJson(StatutDemande statut) {
    switch (statut) {
      case StatutDemande.enAttente:
        return 'en_attente';
      case StatutDemande.acceptee:
        return 'acceptee';
      case StatutDemande.rejetee:
        return 'rejetee';
    }
  }

  DemandeReorientation copyWith({
    StatutDemande? statut,
    String? commentaireAdmin,
  }) {
    return DemandeReorientation(
      id: id,
      nom: nom,
      prenom: prenom,
      filiereActuelleNom: filiereActuelleNom,
      nouvelleFiliereNom: nouvelleFiliereNom,
      motivation: motivation,
      dateCreation: dateCreation,
      dateTraitement: dateTraitement,
      statut: statut ?? this.statut,
      commentaireAdmin: commentaireAdmin ?? this.commentaireAdmin,
      pieceJustificative: pieceJustificative,
      level: level,
      facultyName: facultyName,
    );
  }

  static DateTime? _dateTimeFromJson(String? dateString) {
    return dateString == null ? null : DateTime.tryParse(dateString);
  }

  static String? _dateTimeToJson(DateTime? date) {
    return date?.toIso8601String();
  }

  factory DemandeReorientation.fromJson(Map<String, dynamic> json) =>
      _$DemandeReorientationFromJson(json);

  Map<String, dynamic> toJson() => _$DemandeReorientationToJson(this);
}
