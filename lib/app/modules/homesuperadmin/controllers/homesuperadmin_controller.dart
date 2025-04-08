import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SuperAdminHomeController extends GetxController {
  // Variables d'état
  final isLoading = false.obs;
  final notificationCount = 0.obs;
  final pendingRequests = 0.obs;

  // Listes observables
  final faculties = <String>[].obs;
  final admins = <String>[].obs;
  final requests = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading(true);
      await Future.wait([
        loadFaculties(),
        loadAdmins(),
        loadRequests()
      ]);
      notificationCount(3);
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du chargement initial des données');
    } finally {
      isLoading(false);
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
    pendingRequests(requests.length);
  }

  Future<void> refreshAllData() async {
    try {
      isLoading(true);
      await fetchInitialData();
      Get.snackbar('Succès', 'Données rafraîchies');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du rafraîchissement');
    } finally {
      isLoading(false);
    }
  }

  // Méthodes de navigation complètes
  void navigateToDashboard() => Get.toNamed(Routes.HOME);
  void navigateToFacultyManagement() => Get.toNamed(Routes.FACULTY_MANAGEMENT);
  void navigateToAdminManagement() => Get.toNamed(Routes.ADMIN_MANAGEMENT);
  void navigateToUserManagement() => Get.toNamed(Routes.USER_MANAGEMENT);
  void navigateToRequestManagement() => Get.toNamed(Routes.REQUEST_MANAGEMENT);
  void navigateToPermissionManagement() => Get.toNamed(Routes.PERMISSION_MANAGEMENT);
  void navigateToChat() => Get.toNamed(Routes.CHAT); // Méthode ajoutée
  void navigateToNotificationManagement() => Get.toNamed(Routes.NOTIFICATION);
}