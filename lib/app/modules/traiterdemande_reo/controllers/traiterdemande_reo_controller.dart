import 'package:get/get.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../services/demande_reorientation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class TraiterdemandeReoController extends GetxController {
  final DemandeReorientationService _service = Get.find<DemandeReorientationService>();
  final RxList<DemandeReorientation> demandesEnAttente = <DemandeReorientation>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final _secureStorage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    chargerDemandesEnAttente();
  }

  Future<void> chargerDemandesEnAttente() async {
    try {
      print('Chargement des demandes en attente...');
      isLoading.value = true;
      errorMessage.value = '';
      
      final demandes = await _service.listerDemandesEnAttente();
      print('${demandes.length} demandes en attente récupérées');
      
      demandesEnAttente.value = demandes;
    } catch (e) {
      print('❌ Erreur lors du chargement des demandes: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les demandes',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> traiterDemande(DemandeReorientation demande, bool accepter) async {
    try {
      print('\n=== DÉBUT TRAITEMENT DEMANDE ===');
      print('ID de la demande: ${demande.id}');
      print('Action: ${accepter ? "ACCEPTATION" : "REJET"}');
      print('Données de la demande:');
      print('- Nom: ${demande.nom}');
      print('- Prénom: ${demande.prenom}');
      print('- Statut actuel: ${demande.statut}');
      
      if (demande.id == null) {
        throw Exception('ID de la demande manquant');
      }

      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.traiterDemande(
        demande: demande,
        isAccepted: accepter,
        commentaire: accepter ? "Votre demande a été acceptée." : "Votre demande a été rejetée.",
      );

      print('\nRésultat du traitement:');
      print('- Nouveau statut: ${result.statut}');
      print('- Commentaire: ${result.commentaireAdmin}');
      
      // Mettre à jour la liste des demandes
      final index = demandesEnAttente.indexWhere((d) => d.id == demande.id);
      if (index != -1) {
        demandesEnAttente.removeAt(index);
        print('Demande retirée de la liste des demandes en attente');
      } else {
        print('⚠️ Demande non trouvée dans la liste');
      }
      
      Get.snackbar(
        'Succès',
        accepter ? 'Demande acceptée' : 'Demande rejetée',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Recharger les demandes en attente
      await chargerDemandesEnAttente();
      
      print('=== FIN TRAITEMENT DEMANDE ===\n');
    } on DioException catch (e) {
      print('\n❌ ERREUR DIO DÉTAILLÉE:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Méthode: ${e.requestOptions.method}');
      print('Headers: ${e.requestOptions.headers}');
      print('Data: ${e.requestOptions.data}');
      
      if (e.response != null) {
        print('\nRéponse du serveur:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        
        String messageErreur = 'Impossible de traiter la demande';
        if (e.response?.data != null) {
          if (e.response?.data['errors'] != null) {
            final errors = e.response?.data['errors'] as Map<String, dynamic>;
            if (errors.containsKey('status')) {
              messageErreur = 'Statut invalide: ${errors['status'].first}';
            } else {
              messageErreur = errors.values.first.first.toString();
            }
          } else if (e.response?.data['message'] != null) {
            messageErreur = e.response?.data['message'];
          }
        }
        
        errorMessage.value = messageErreur;
        Get.snackbar(
          'Erreur',
          messageErreur,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e, stackTrace) {
      print('\n❌ ERREUR INATTENDUE:');
      print('Message: $e');
      print('Stack trace: $stackTrace');
      
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void actualiserDonnees() {
    print('Actualisation des données demandée');
    chargerDemandesEnAttente();
  }
}
