import 'package:get/get.dart';

class DemandeReorientationController extends GetxController {
  var isLoading = false.obs;
  var isSubmitted = false.obs;

  // Méthode pour soumettre une demande de réorientation
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

    // Simulation de la soumission d'une demande
    await Future.delayed(Duration(seconds: 2));

    // Logique de traitement
    print("Demande de réorientation soumise pour l'étudiant $nom $prenom");
    print("Nouvelle filière souhaitée : $nouvelleFiliere");

    // Mise à jour de l'état
    isSubmitted.value = true;
    isLoading.value = false;
  }
}
