import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'demande_transfert_etudiant_model.g.dart';

@JsonSerializable()
class DemandeTransfertEtudiant {
  int? id;
  String nomEtudiant;
  String prenomEtudiant;
  String email;
  String faculteOrigine;
  String faculteDestination;
  String filiere; // Même filière conservée
  String motivation;
  String? cheminDocument;
  String statut;
  DateTime? dateCreation;
  DateTime? dateTraitement;
  String? commentaireAdministration;

  DemandeTransfertEtudiant({
    this.id,
    required this.nomEtudiant,
    required this.prenomEtudiant,
    required this.email,
    required this.faculteOrigine,
    required this.faculteDestination,
    required this.filiere,
    required this.motivation,
    this.cheminDocument,
    this.statut = 'EN_ATTENTE',
    this.dateCreation,
    this.dateTraitement,
    this.commentaireAdministration,
  });

  factory DemandeTransfertEtudiant.fromJson(Map<String, dynamic> json) =>
      _$DemandeTransfertEtudiantFromJson(json);

  Map<String, dynamic> toJson() => _$DemandeTransfertEtudiantToJson(this);
}