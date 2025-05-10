import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemandeTransfertEnseignantController extends GetxController {
  // États observables
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Méthode de soumission de demande
  Future<void> soumettreDemandeTransfertEnseignant({
    required String nom,
    required String prenom,
    required String email,

    required String faculteActuelle,

    required String motivation,
    File? document, required String faculteDestination,
  }) async {
    try {
      // Validation des données
      if (_validateInputs(
          nom,
          prenom,
          email,
          faculteActuelle,
          faculteDestination,
          motivation,
          document?.path ??  '',

      )) {
        // Mettre l'état en chargement
        isLoading.value = true;

        // Simulation de la soumission de la demande (à remplacer par un appel API réel)
        await Future.delayed(Duration(seconds: 2));

        // Affichage d'un message de succès
        Get.snackbar(
          'Succès',
          'Votre demande de transfert a été soumise avec succès.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Gestion des erreurs
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erreur',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Fin du chargement
      isLoading.value = false;
    }
  }

  // Méthode de validation des entrées
  bool _validateInputs(
      String nom,
      String prenom,
      String email,
      String universiteActuelle,
      String faculteActuelle,
      String universiteDemandee,
      String motivation,
      ) {
    // Vérification des champs obligatoires
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs obligatoires.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Vérification que les universités sont différentes
    if (universiteActuelle == universiteDemandee) {
      Get.snackbar(
        'Erreur',
        'L\'université de destination doit être différente de l\'université actuelle.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Vérification de la motivation
    if (motivation.length < 10) {
      Get.snackbar(
        'Erreur',
        'La motivation doit contenir au moins 10 caractères.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}