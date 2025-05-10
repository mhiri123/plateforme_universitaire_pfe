import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../services/demande_reorientation_service.dart';
import '../../home/controllers/user_controller.dart';

class DemandeReorientationController extends GetxController with StateMixin<List<DemandeReorientation>> {
  late final DemandeReorientationService _service;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DemandeReorientation?> demandeCourante = Rx<DemandeReorientation?>(null);
  final RxList<DemandeReorientation> mesDemandesReorientation = <DemandeReorientation>[].obs;
  final RxList<DemandeReorientation> demandesEnAttente = <DemandeReorientation>[].obs;
  late final UserController userController;

  @override
  void onInit() {
    super.onInit();
    _service = Get.find<DemandeReorientationService>();
    userController = Get.find<UserController>();
    _chargerDonnees();
  }

  void _chargerDonnees() {
    Future.wait([
      chargerDemandesEnAttente(),
      chargerMesDemandesReorientation(),
    ]);
  }

  Future<void> soumettreDemandeReorientation({
    required String nouvelleFiliere,
    required String motivation,
    required File pieceJustificative,
  }) async {
    final nom = userController.getNom();
    final prenom = userController.getPrenom();
    final filiereActuelle = userController.getFiliere();
    final niveau = userController.getNiveauLibelle();
    final faculte = userController.getFaculte();

    // Conversion des ID des filières en int si nécessaire
    final int filiereActuelleId = int.tryParse(filiereActuelle) ?? 0;
    final int nouvelleFiliereId = int.tryParse(nouvelleFiliere) ?? 0;

    final validationResult = _validateDonnees(
      nom: nom,
      prenom: prenom,
      filiereActuelle: filiereActuelle,
      choixNouvelleFiliere: nouvelleFiliere,
      motivation: motivation,
      level: niveau,
      facultyName: faculte,
      pieceJustificative: pieceJustificative,
    );

    if (!validationResult.isValid) {
      _showErrorNotification(validationResult.errors.join('\n'));
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.soumettreDemande(
        nom: nom,
        prenom: prenom,
        filiereActuelleNom: filiereActuelle,
        nouvelleFiliereNom: nouvelleFiliere,
        motivation: motivation,
        level: niveau,
        facultyName: faculte,
        pieceJustificative: pieceJustificative,
      );

      demandeCourante.value = result;
      mesDemandesReorientation.add(result);
      demandesEnAttente.add(result);

      _showSuccessNotification("Demande soumise avec succès");
    } catch (e) {
      errorMessage.value = e.toString();
      _showErrorNotification(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> chargerDemandesEnAttente() async {
    try {
      change(null, status: RxStatus.loading());

      final demandes = await _service.listerDemandesEnAttente();
      demandesEnAttente.value = demandes;

      change(demandes, status: RxStatus.success());
    } catch (e) {
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(e.toString()));
      _showErrorNotification(errorMessage.value);
    }
  }

  Future<void> chargerMesDemandesReorientation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final demandes = await _service.listerMesDemandesReorientation();
      mesDemandesReorientation.value = demandes;
    } catch (e) {
      errorMessage.value = e.toString();
      _showErrorNotification(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> traiterDemandeReorientation({
    required DemandeReorientation demande,
    required bool accepter,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _service.traiterDemande(
        demande: demande,
        isAccepted: true,
        commentaire: "Votre demande a été acceptée.",
      );
      final demandeModifiee = demande.copyWith(
        statut: accepter ? StatutDemande.acceptee : StatutDemande.rejetee,
      );

      // Mise à jour des listes
      demandesEnAttente.removeWhere((d) => d.id == demande.id);
      mesDemandesReorientation.add(demandeModifiee);

      _showSuccessNotification(accepter ? 'Demande acceptée' : 'Demande rejetée');
    } catch (e) {
      errorMessage.value = e.toString();
      _showErrorNotification(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


  ValidationResult _validateDonnees({
    required String nom,
    required String prenom,
    required String filiereActuelle,
    required String choixNouvelleFiliere,
    required String motivation,
    required String level,
    required String facultyName,
    File? pieceJustificative,
  }) {
    final errors = <String>[];

    if (nom.trim().isEmpty) errors.add('Le nom est obligatoire');
    if (prenom.trim().isEmpty) errors.add('Le prénom est obligatoire');
    if (filiereActuelle.trim().isEmpty) errors.add('La filière actuelle est requise');
    if (choixNouvelleFiliere.trim().isEmpty) errors.add('La nouvelle filière est requise');
    if (motivation.trim().length < 10) errors.add('La motivation doit contenir au moins 10 caractères');
    if (filiereActuelle.trim() == choixNouvelleFiliere.trim()) errors.add('La nouvelle filière doit être différente');
    if (pieceJustificative == null) errors.add('Une pièce justificative est requise');
    if (level.trim().isEmpty) errors.add('Le niveau est requis');
    if (facultyName.trim().isEmpty) errors.add('La faculté est requise');

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  void _showSuccessNotification(String message) {
    Get.snackbar(
      'Succès',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorNotification(String message) {
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  void reinitialiserEtats() {
    demandeCourante.value = null;
    errorMessage.value = '';
    mesDemandesReorientation.clear();
    demandesEnAttente.clear();
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, this.errors = const []});
}
