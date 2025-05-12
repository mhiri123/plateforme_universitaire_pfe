import 'package:get/get.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../models/demande_transfert_enseignant_model.dart';
import '../../../models/demande_transfert_etudiant_model.dart';
import '../../../services/demande_reorientation_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AdminHomeController extends GetxController {
  final RxList<DemandeReorientation> demandesReorientation = <DemandeReorientation>[].obs;
  final RxList<DemandeTransfertEtudiant> demandesTransfertEtudiant = <DemandeTransfertEtudiant>[].obs;
  final RxList<DemandeTransfertEnseignant> demandesTransfertEnseignant = <DemandeTransfertEnseignant>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt nombreDemandesEnAttente = 0.obs;
  final RxString nomFaculte = ''.obs;

  late final DemandeReorientationService _service;
  final _storage = GetStorage();
  final _secureStorage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _service = Get.find<DemandeReorientationService>();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Récupérer le nom de la faculté de l'admin
      final userRole = _storage.read('userRole');
      final userEmail = _storage.read('userEmail');
      
      if (userRole != 'admin') {
        throw Exception('Accès non autorisé');
      }

      // Charger les demandes de réorientation
      await recupererDemandesReorientation();
      
      // Mettre à jour le compteur de demandes en attente
      nombreDemandesEnAttente.value = demandesReorientation
          .where((demande) => demande.statut == StatutDemande.enAttente)
          .length;

      // Charger les autres types de demandes si nécessaire
      await recupererDemandesTransfertEtudiant();
      await recupererDemandesTransfertEnseignant();

    } catch (e) {
      print('❌ Erreur lors du chargement des données: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recupererDemandesReorientation() async {
    try {
      final demandes = await _service.listerDemandesEnAttente();
      demandesReorientation.value = demandes;
    } catch (e) {
      print('❌ Erreur lors de la récupération des demandes de réorientation: $e');
      errorMessage.value = 'Erreur lors de la récupération des demandes de réorientation';
      rethrow;
    }
  }

  Future<void> recupererDemandesTransfertEtudiant() async {
    try {
      // Implémenter la récupération des demandes de transfert étudiant
      demandesTransfertEtudiant.value = [];
    } catch (e) {
      print('❌ Erreur lors de la récupération des demandes de transfert étudiant: $e');
      errorMessage.value = 'Erreur lors de la récupération des demandes de transfert étudiant';
    }
  }

  Future<void> recupererDemandesTransfertEnseignant() async {
    try {
      // Implémenter la récupération des demandes de transfert enseignant
      demandesTransfertEnseignant.value = [];
    } catch (e) {
      print('❌ Erreur lors de la récupération des demandes de transfert enseignant: $e');
      errorMessage.value = 'Erreur lors de la récupération des demandes de transfert enseignant';
    }
  }

  Future<void> traiterDemandeReorientation(DemandeReorientation demande, bool accepter) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _service.traiterDemande(
        demande: demande,
        isAccepted: accepter,
        commentaire: accepter ? "Votre demande a été acceptée." : "Votre demande a été rejetée.",
      );

      // Mettre à jour la liste des demandes
      await recupererDemandesReorientation();
      
      // Mettre à jour le compteur
      nombreDemandesEnAttente.value = demandesReorientation
          .where((d) => d.statut == StatutDemande.enAttente)
          .length;

      Get.snackbar(
        'Succès',
        accepter ? 'Demande acceptée' : 'Demande rejetée',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Erreur lors du traitement de la demande: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors du traitement de la demande',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void actualiserDonnees() {
    _chargerDonnees();
  }
}
