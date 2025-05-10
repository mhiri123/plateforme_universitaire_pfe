import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SuperAdminHomeController extends GetxController {
  // Variables d'état
  var isLoading = false.obs;
  var notificationCount = 0.obs;
  var pendingRequests = 0.obs;

  // Listes observables
  var faculties = <String>[].obs;
  var admins = <String>[].obs;
  var requests = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading.value = true; // Utilisation de .value pour modifier l'état
      await Future.wait([
        loadFaculties(),
        loadAdmins(),
        loadRequests()
      ]);
      notificationCount.value = 3; // Mise à jour avec .value
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du chargement initial des données');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFaculties() async {
    await Future.delayed(const Duration(seconds: 1));
    faculties.assignAll([
      "Faculté de Médecine",
      "Faculté des Sciences",
      "Faculté d'Informatique"
    ]);
  }

  Future<void> loadAdmins() async {
    await Future.delayed(const Duration(seconds: 1));
    admins.assignAll(["Admin 1", "Admin 2", "Admin 3"]);
  }

  Future<void> loadRequests() async {
    await Future.delayed(const Duration(seconds: 1));
    requests.assignAll([
      "Demande de transfert 1",
      "Demande de réorientation 2"
    ]);
    pendingRequests.value = requests.length; // Utilisation de .value
  }

  Future<void> refreshAllData() async {
    try {
      isLoading.value = true;
      await fetchInitialData();
      Get.snackbar('Succès', 'Données rafraîchies');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du rafraîchissement');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthodes de navigation
  void navigateToDashboard() => Get.toNamed(Routes.HOME);
  void navigateToFacultyManagement() => Get.toNamed(Routes.FACULTY_MANAGEMENT);
  void navigateToAdminManagement() => Get.toNamed(Routes.ADMIN_MANAGEMENT);
  void navigateToUserManagement() => Get.toNamed(Routes.USER_MANAGEMENT);
  void navigateToRequestManagement() => Get.toNamed(Routes.REQUEST_MANAGEMENT);
  void navigateToPermissionManagement() => Get.toNamed(Routes.PERMISSION_MANAGEMENT);
  void navigateToChat() => Get.toNamed(Routes.CHAT);
  void navigateToNotificationManagement() => Get.toNamed(Routes.NOTIFICATION);
}
