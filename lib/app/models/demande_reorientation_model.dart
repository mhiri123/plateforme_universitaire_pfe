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
  rejetee,
}

@JsonSerializable(explicitToJson: true)
class DemandeReorientation {
  @JsonKey(includeIfNull: false)
  final int? id;

  final String nom;
  final String prenom;

  @JsonKey(name: 'filiere_actuelle_nom')
  final String filiereActuelleNom;  // Correspond au nom de la filière actuelle

  @JsonKey(name: 'nouvelle_filiere_nom')
  final String nouvelleFiliereNom;  // Correspond au nom de la nouvelle filière

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
    name: 'status', // Correspond à 'status' dans la table Laravel
    defaultValue: StatutDemande.enAttente,
  )
  final StatutDemande statut;

  @JsonKey(name: 'commentaire_admin', includeIfNull: false)
  final String? commentaireAdmin;

  @JsonKey(name: 'piece_justificative', includeIfNull: false)
  final String? pieceJustificative;

  final String level; // Niveau d'études
  final String facultyName; // Nom de la faculté

  DemandeReorientation({
    this.id,
    required this.nom,
    required this.prenom,
    required this.filiereActuelleNom, // Nom de la filière actuelle
    required this.nouvelleFiliereNom, // Nom de la nouvelle filière
    required this.motivation,
    this.dateCreation,
    this.dateTraitement,
    this.statut = StatutDemande.enAttente,
    this.commentaireAdmin,
    this.pieceJustificative,
    required this.level,
    required this.facultyName,
  });

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

  // Helper pour affichage lisible du statut
  String get statutTexte {
    switch (statut) {
      case StatutDemande.enAttente:
        return 'En attente';
      case StatutDemande.acceptee:
        return 'Acceptée';
      case StatutDemande.rejetee:
        return 'Rejetée';
    }
  }
}
