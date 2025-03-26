import 'package:get/get.dart';

class DemandeTransfertController extends GetxController {
  var isLoading = false.obs;
  var isSubmitted = false.obs;

  // Méthode pour soumettre la traiterdemande de transfert
  void soumettreDemandeTransfert(
      String statut,
      String nom,
      String prenom,
      String numeroIdentification,
      String dateNaissance,
      String email,
      String telephone,
      String institutActuel,
      String departement,
      String filiere,
      String anneeEtude,
      String discipline,
      String typeContrat,
      String institutDemande,
      String departementDemande,
      String dateTransfert,
      String motivation) async {
    isLoading.value = true;

    // Simulation d'une traiterdemande soumise
    await Future.delayed(Duration(seconds: 2));

    // Logique de traitement (ex. envoyer la traiterdemande au backend ou enregistrer dans la base de données)
    print("Demande de transfert soumise pour $statut $nom $prenom");
    print("Institut demandé : $institutDemande");

    // Une fois la traiterdemande soumise
    isSubmitted.value = true;
    isLoading.value = false;
  }
}
