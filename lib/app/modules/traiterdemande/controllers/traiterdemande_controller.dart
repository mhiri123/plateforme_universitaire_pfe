import 'package:get/get.dart';

class DemandeController extends GetxController {
  // Pour garder la trace de la demande en cours
  var demande = {}.obs;
  var isLoading = false.obs;

  // Méthode pour initialiser les informations de la demande
  void setDemande(Map<String, String> nouvelleDemande) {
    demande.value = nouvelleDemande;
  }

  // Méthode pour traiter la demande (accepter ou refuser)
  void traiterDemande(bool estAcceptee) {
    isLoading.value = true;

    // Logique pour accepter ou refuser
    if (estAcceptee) {
      print("Demande acceptée pour ${demande['nom']}");
    } else {
      print("Demande rejetée pour ${demande['nom']}");
    }

    // Une fois la demande traitée, on réinitialise la demande pour l'écran
    isLoading.value = false;
    demande.value = {}; // Réinitialiser la demande après traitement
  }
}
