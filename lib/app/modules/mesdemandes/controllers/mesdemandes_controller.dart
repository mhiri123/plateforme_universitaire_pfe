import 'package:get/get.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../services/demande_reorientation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MesdemandesController extends GetxController {
  final DemandeReorientationService _service = Get.find<DemandeReorientationService>();
  final RxList<DemandeReorientation> mesDemandes = <DemandeReorientation>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    chargerMesDemandes();
  }

  Future<void> chargerMesDemandes() async {
    try {
      print('Chargement des demandes de l\'étudiant...');
      isLoading.value = true;
      errorMessage.value = '';
      
      final userId = _storage.read('userId');
      if (userId == null) {
        throw Exception('ID utilisateur non trouvé');
      }

      final demandes = await _service.listerMesDemandesReorientation(int.parse(userId.toString()));
      print('${demandes.length} demandes récupérées');
      
      mesDemandes.value = demandes;
    } catch (e) {
      print('❌ Erreur lors du chargement des demandes: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger vos demandes',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getStatutLibelle(StatutDemande statut) {
    return statut.toString().split('.').last;
  }

  Color getStatutColor(StatutDemande statut) {
    switch (statut) {
      case StatutDemande.enAttente:
        return Colors.orange;
      case StatutDemande.acceptee:
        return Colors.green;
      case StatutDemande.rejetee:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void actualiserDonnees() {
    print('Actualisation des données demandée');
    chargerMesDemandes();
  }
} 