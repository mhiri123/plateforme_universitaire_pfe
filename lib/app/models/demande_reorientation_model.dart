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
  @JsonKey(includeIfNull: false, fromJson: _parseIdValue)
  final int? id;

  @JsonKey(name: 'user_id', includeIfNull: false, fromJson: _parseIdValue)
  final int? userId;

  // adminId est utilisé pour les notifications uniquement
  @JsonKey(name: 'admin_id', includeIfNull: false, fromJson: _parseIdValue)
  final int? adminId;

  @JsonKey(defaultValue: '')
  final String nom;

  @JsonKey(defaultValue: '')
  final String prenom;

  @JsonKey(defaultValue: '')
  final String niveau;

  @JsonKey(name: 'filiere_actuelle_nom', defaultValue: '')
  final String filiereActuelleNom; // Correspond au nom de la filière actuelle

  @JsonKey(name: 'nouvelle_filiere_nom', defaultValue: '')
  final String nouvelleFiliereNom; // Correspond au nom de la nouvelle filière

  @JsonKey(defaultValue: '')
  final String motivation;

  @JsonKey(
    name: 'created_at',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime? dateCreation;

  // Note: dateTraitement n'est pas stocké dans la base de données
  @JsonKey(
    name: 'date_traitement',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
    includeIfNull: false,
  )
  final DateTime? dateTraitement;

  // Support pour le champ status utilisé dans la base de données
  @JsonKey(
    name: 'status',
    fromJson: _statutFromJson,
    toJson: _statutToJson,
    defaultValue: StatutDemande.enAttente,
  )
  final StatutDemande statut;

  @JsonKey(
    name: 'statut',
    includeIfNull: false,
    fromJson: _statutFromJson,
    toJson: _statutToJson,
  )
  final StatutDemande? statutFallback;

  // Note: commentaire est utilisé pour les communications API mais n'est pas stocké en BD
  @JsonKey(name: 'commentaire', includeIfNull: false)
  final String? commentaire;

  @JsonKey(name: 'piece_justificative', includeIfNull: false)
  final String? pieceJustificative;

  @JsonKey(name: 'faculty_name', defaultValue: '')
  final String facultyName; // Nom de la faculté

  @JsonKey(includeIfNull: false)
  final dynamic
      user; // Pour supporter l'inclusion de l'utilisateur dans les réponses

  // Getter pour compatibilité avec le code existant
  String get level => niveau;

  // Getter pour compatibilité avec le code existant qui utilisait commentaireAdmin
  String? get commentaireAdmin => commentaire;

  DemandeReorientation({
    this.id,
    this.userId,
    this.adminId,
    required this.nom,
    required this.prenom,
    this.niveau = '',
    required this.filiereActuelleNom,
    required this.nouvelleFiliereNom,
    required this.motivation,
    this.dateCreation,
    this.dateTraitement,
    this.statut = StatutDemande.enAttente,
    this.statutFallback,
    this.commentaire,
    this.pieceJustificative,
    required this.facultyName,
    this.user,
  });

  static StatutDemande _statutFromJson(dynamic value) {
    if (value == null) return StatutDemande.enAttente;

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'en_attente':
          return StatutDemande.enAttente;
        case 'acceptee':
        case 'acceptée':
          return StatutDemande.acceptee;
        case 'rejetee':
        case 'rejetée':
          return StatutDemande.rejetee;
        default:
          return StatutDemande.enAttente;
      }
    }
    return StatutDemande.enAttente;
  }

  static String _statutToJson(StatutDemande? statut) {
    if (statut == null) return 'en_attente';

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
    String? commentaire,
    int? userId,
    int? adminId,
    String? niveau,
  }) {
    return DemandeReorientation(
      id: id,
      userId: userId ?? this.userId,
      adminId: adminId ?? this.adminId,
      nom: nom,
      prenom: prenom,
      niveau: niveau ?? this.niveau,
      filiereActuelleNom: filiereActuelleNom,
      nouvelleFiliereNom: nouvelleFiliereNom,
      motivation: motivation,
      dateCreation: dateCreation,
      dateTraitement: dateTraitement,
      statut: statut ?? this.statut,
      statutFallback: statut, // Mettre à jour aussi le statutFallback
      commentaire: commentaire ?? this.commentaire,
      pieceJustificative: pieceJustificative,
      facultyName: facultyName,
      user: user,
    );
  }

  static DateTime? _dateTimeFromJson(String? dateString) {
    return dateString == null ? null : DateTime.tryParse(dateString);
  }

  static String? _dateTimeToJson(DateTime? date) {
    return date?.toIso8601String();
  }

  static int? _parseIdValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory DemandeReorientation.fromJson(Map<String, dynamic> json) {
    // Si les données sont encapsulées dans un champ data, les extraire
    if (json.containsKey('data') && json['data'] != null) {
      return _$DemandeReorientationFromJson(
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json,
      );
    }
    // Si nous avons une demande encapsulée dans un champ demande
    if (json.containsKey('demande') && json['demande'] != null) {
      return _$DemandeReorientationFromJson(
        json['demande'] is Map<String, dynamic>
            ? json['demande'] as Map<String, dynamic>
            : json,
      );
    }
    return _$DemandeReorientationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = _$DemandeReorientationToJson(this);

    // Supprimer les champs qui n'existent pas dans la base de données
    // mais utiliser commentaire au lieu de commentaire_admin
    if (json.containsKey('commentaire_admin')) {
      json.remove('commentaire_admin');
    }

    if (this.commentaire != null) {
      json['commentaire'] = this.commentaire;
    }

    return json;
  }
}
