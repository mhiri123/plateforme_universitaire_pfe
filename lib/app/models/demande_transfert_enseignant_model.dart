import 'package:json_annotation/json_annotation.dart';

part 'demande_transfert_enseignant_model.g.dart';

@JsonSerializable()
class DemandeTransfertEnseignant {
  int? id;
  String nom;
  String prenom;
  String email;
  String universiteActuelle;
  String faculteActuelle;
  String universiteDemandee;
  String motivation;
  String? cheminDocument;
  String statut;
  DateTime? dateCreation;
  DateTime? dateTraitement;
  String? commentaireAdministration;

  DemandeTransfertEnseignant({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.universiteActuelle,
    required this.faculteActuelle,
    required this.universiteDemandee,
    required this.motivation,
    this.cheminDocument,
    this.statut = 'EN_ATTENTE',
    this.dateCreation,
    this.dateTraitement,
    this.commentaireAdministration,
  });

  // Statuts possibles
  static const String STATUT_EN_ATTENTE = 'EN_ATTENTE';
  static const String STATUT_ACCEPTE = 'ACCEPTE';
  static const String STATUT_REFUSE = 'REFUSE';
  static const String STATUT_ANNULE = 'ANNULE';

  // Méthodes de sérialisation JSON
  factory DemandeTransfertEnseignant.fromJson(Map<String, dynamic> json) =>
      _$DemandeTransfertEnseignantFromJson(json);

  Map<String, dynamic> toJson() => _$DemandeTransfertEnseignantToJson(this);

  // Méthode pour obtenir le libellé du statut
  String get statutLibelle {
    switch (statut) {
      case STATUT_EN_ATTENTE:
        return 'En attente';
      case STATUT_ACCEPTE:
        return 'Accepté';
      case STATUT_REFUSE:
        return 'Refusé';
      case STATUT_ANNULE:
        return 'Annulé';
      default:
        return 'Statut inconnu';
    }
  }
}