import 'package:get/get.dart';

class DemandeController extends GetxController {
  var demandes = [].obs; // Liste des demandes

  void ajouterDemande(String type, String description) {
    var nouvelleDemande = {
      "type": type,
      "description": description,
      "statut": "En attente"
    };
    demandes.add(nouvelleDemande);
    Get.snackbar("Succès", "Votre demande a été envoyée avec succès.");
  }

  void traiterDemande(int index, String nouveauStatut) {
    demandes[index]["statut"] = nouveauStatut;
    Get.snackbar("Mise à jour", "Le statut de la demande a été modifié.");
    update();
  }
}
