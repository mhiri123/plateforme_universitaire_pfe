import 'package:get/get.dart';

class DemandeReorientationController extends GetxController {
  var isLoading = false.obs;
  var isSubmitted = false.obs;

  // Méthode pour soumettre la traiterdemande de réorientation
  void soumettreDemandeReorientation(
      String nom,
      String prenom,
      String numeroEtudiant,
      String dateNaissance,
      String email,
      String telephone,
      String filiereActuelle,
      String anneeEtude,
      String departement,
      String nouvelleFiliere,
      String departementSouhaite,
      String dateChangement,
      String motivation) async {
    isLoading.value = true;

    // Simulation d'une traiterdemande soumise
    await Future.delayed(Duration(seconds: 2));

    // Logique de traitement (ex. envoyer la traiterdemande au backend ou enregistrer dans la base de données)
    print("Demande de réorientation soumise pour l'étudiant $nom $prenom");
    print("Nouvelle filière souhaitée : $nouvelleFiliere");

    // Une fois la traiterdemande soumise
    isSubmitted.value = true;
    isLoading.value = false;
  }
}
