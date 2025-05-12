import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/auth_response.dart';
import '../../../services/api_service.dart';
import '../../../services/demande_reorientation_service.dart';
import '../../../services/notification_service.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demande_reorientation_controller.dart';
import '../../demandetransfert_etudiant/controllers/demandetransfertenseignant_controller.dart';
import '../../demandetransfetenseignant/controllers/demandetransfetenseignant_controller.dart';
import '../../home/controllers/user_controller.dart';
import '../../homeadmin/views/homeadmin_view.dart';
import '../../homestudent/views/homestudent_view.dart';
import '../../homesuperadmin/views/homesuperadmin_view.dart';
import '../../hometeacher/views/hometeacher_view.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../unknown_role/views/unknown_role_view.dart';

class LoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final Dio _dio = Get.find<Dio>();
  final ApiService _apiService = Get.find<ApiService>();
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showErrorSnackbar("Veuillez remplir tous les champs");
      return;
    }

    isLoading.value = true;

    try {
      final loginData = {
        'email': email,
        'password': password,
      };

      final AuthResponse authResponse = await _apiService.login(loginData);
      final User user = authResponse.user;

      print("Connecté en tant que : ${user.email}");

      final token = authResponse.token;
      if (token != null && token.isNotEmpty) {
        await _storage.write(key: 'auth_token', value: token);
        print("Token stocké : $token");
      } else {
        print("⚠️ Token manquant dans la réponse");
        throw Exception("Token d'authentification manquant");
      }

      final box = GetStorage();
      await box.write('userId', user.id.toString());
      await box.write('userName', '${user.prenom} ${user.nom}');
      await box.write('userRole', user.role);
      await box.write('userEmail', user.email);

      print("Données utilisateur stockées :");
      print("userId: ${user.id}");
      print("userName: ${user.prenom} ${user.nom}");
      print("userRole: ${user.role}");
      print("userEmail: ${user.email}");

      final userController = Get.put(UserController());
      await userController.setUser(user.email, user.role, user.id);
      
      final NotificationService notificationService = Get.put(NotificationService(
        secureStorage: Get.find<FlutterSecureStorage>(),
      ));
      Get.put(NotificationController(Get.find<NotificationService>()));

      _initializeControllers();
      _redirectBasedOnRole(user.role);
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      debugPrint("Dio error: $errorMessage");
      showErrorSnackbar(errorMessage);
    } catch (e, stackTrace) {
      if (e is DioError && e.error is SocketException) {
        showErrorSnackbar("Vérifiez votre connexion Internet.");
      } else {
        debugPrint("Erreur inattendue : $e");
        debugPrintStack(stackTrace: stackTrace);
        showErrorSnackbar("Une erreur inattendue est survenue");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeControllers() {
    Get.put(DemandeReorientationService(dio: Get.find<Dio>()));
    Get.put(ChatController());
    Get.put(DemandeTransfertEtudiantController());
    Get.put(DemandeTransfertEnseignantController());
    Get.put(DemandeReorientationController());
  }

  void _redirectBasedOnRole(String role) {
    final roleScreens = {
      "super_admin": SuperAdminHomeScreen(),
      "admin": AdminHomeScreen(),
      "enseignant": TeacherHomeScreen(),
      "etudiant": HomestudentView(),
    };

    final screen = roleScreens[role.toLowerCase()];
    if (screen != null) {
      Get.offAll(() => screen);
    } else {
      showErrorSnackbar("Rôle utilisateur non reconnu");
      Get.offAll(() => const UnknownRoleScreen());
    }
  }

  String _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return "Requête invalide";
      case 401:
        return "Identifiants incorrects";
      case 403:
        return "Accès non autorisé";
      case 404:
        return "Ressource non trouvée";
      case 500:
        return "Erreur serveur";
      default:
        return e.message ?? "Erreur réseau";
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Erreur",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
