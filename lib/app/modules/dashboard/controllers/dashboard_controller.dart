import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Variables observables pour les statistiques
  var pendingRequests = 0.obs;
  var acceptedRequests = 0.obs;
  var rejectedRequests = 0.obs;

  // Liste des activités récentes
  var activities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialisation des valeurs par défaut
    fetchDashboardData();
  }

  // Exemple de méthode pour récupérer des données (en simulation ici)
  void fetchDashboardData() {
    // Remplissage avec des données d'exemple
    pendingRequests.value = 5;
    acceptedRequests.value = 10;
    rejectedRequests.value = 2;

    activities.assignAll([
      "Réception demande de transfert",
      "Réception demande de réorientation",
      "Demande acceptée",
      "Demande rejetée",
      "Nouvelle activité"
    ]);
  }
}
