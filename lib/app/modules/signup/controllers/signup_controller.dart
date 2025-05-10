import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../models/reference_models.dart';
import '../../../services/api_service.dart';

class SignUpController extends GetxController {
  // Retrofit API service
  late final ApiService apiService;

  SignUpController() {
    final dio = Dio();
    apiService = ApiService(dio);
  }

  // Dropdown data
  var roles = <RoleModel>[].obs;
  var faculties = <FacultyModel>[].obs;
  var filieres = <FiliereModel>[].obs;
  var levels = <LevelModel>[].obs;

  // Selected values
  var selectedRole = Rxn<RoleModel>();
  var selectedFaculty = Rxn<FacultyModel>();
  var selectedFiliere = Rxn<FiliereModel>();
  var selectedLevel = Rxn<LevelModel>();

  // Loading indicator
  var isLoading = false.obs;

  // Form controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    print('🟢 [DEBUG] SignUpController initialisé');
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    fetchRoles();
    fetchFaculties();
    fetchLevels();
  }

  void fetchRoles() async {
    print('🔄 [DEBUG] Début de fetchRoles...');
    try {
      final response = await apiService.getRoles();
      print('✅ [DEBUG] Rôles récupérés : ${response.data.length}');
      roles.assignAll(response.data);
    } catch (e) {
      print('❌ [ERROR] fetchRoles: $e');
    }
  }

  void fetchFaculties() async {
    print('🔄 [DEBUG] Début de fetchFaculties...');
    try {
      final response = await apiService.getFaculties();
      print('✅ [DEBUG] Facultés récupérées : ${response.data.length} éléments');

      faculties.assignAll(
        response.data.where((f) => f.gouvernorat?.toLowerCase() == 'sfax').toList(),
      );

      print('✅ [DEBUG] Facultés filtrées (Sfax) : ${faculties.length}');
      if (faculties.isEmpty) {
        Get.snackbar('Erreur', 'Aucune faculté située à Sfax n’a été trouvée.');
      }
    } catch (e) {
      print('❌ [ERROR] fetchFaculties: $e');
      Get.snackbar('Erreur', 'Impossible de charger les facultés.');
    }
  }

  void fetchLevels() async {
    print('🔄 [DEBUG] Début de fetchLevels...');
    try {
      final response = await apiService.getLevels();
      print('✅ [DEBUG] Niveaux récupérés : ${response.data.length}');
      levels.assignAll(response.data);
    } catch (e) {
      print('❌ [ERROR] fetchLevels: $e');
    }
  }

  void fetchFilieresByFaculty(String facultyName) async {
    print('🔄 [DEBUG] Début de fetchFilieres pour $facultyName');
    try {
      final response = await apiService.getFilieres(facultyName: facultyName);
      print('✅ [DEBUG] Filières récupérées : ${response.data.length}');
      filieres.assignAll(response.data);
    } catch (e) {
      print('❌ [ERROR] fetchFilieres: $e');
    }
  }

  // Dropdown logic
  void onRoleSelected(RoleModel? role) {
    selectedRole.value = role;
    if (role?.name?.toLowerCase() != 'etudiant') {
      selectedLevel.value = null;
    }
  }

  void onFacultySelected(FacultyModel? faculty) {
    selectedFaculty.value = faculty;
    selectedFiliere.value = null;
    if (faculty?.facultyName != null) {
      fetchFilieresByFaculty(faculty!.facultyName!);
    }
  }

  void onFiliereSelected(FiliereModel? filiere) {
    selectedFiliere.value = filiere;
  }

  void onLevelSelected(LevelModel? level) {
    selectedLevel.value = level;
  }

  void signUp(BuildContext context) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedRole.value == null ||
        selectedFaculty.value == null ||
        (selectedRole.value?.name?.toLowerCase() == 'etudiant' && selectedLevel.value == null)) {
      Get.snackbar('Erreur', 'Veuillez remplir tous les champs obligatoires');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Erreur', 'Les mots de passe ne correspondent pas');
      return;
    }

    isLoading.value = true;

    final registerData = {
      'prenom': firstNameController.text,
      'nom': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text,
      'role_id': selectedRole.value?.id,
      'faculty_id': selectedFaculty.value?.id,
      'filiere_id': selectedFiliere.value?.id,
      'niveau': selectedLevel.value?.level ?? 'L1',
    };

    try {
      print('📤 [DEBUG] Données d\'inscription envoyées : $registerData');
      final response = await apiService.register(registerData);
      if (response != null) {
        print('✅ [DEBUG] Inscription réussie');
        Get.snackbar('Succès', 'Inscription réussie');
        resetForm();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('❌ [ERROR] signUp: $e');
      Get.snackbar('Erreur', 'Échec de l\'inscription : $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole.value = null;
    selectedFaculty.value = null;
    selectedFiliere.value = null;
    selectedLevel.value = null;
    filieres.clear();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
