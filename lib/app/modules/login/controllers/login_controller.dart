import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../models/user.dart';
import '../../../sevices/api_service.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../homeadmin/views/homeadmin_view.dart';
import '../../homestudent/views/homestudent_view.dart';
import '../../hometeacher/views/hometeacher_view.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  late ApiService apiService;

  @override
  void onInit() {
    super.onInit();
    apiService = ApiService(Dio());
  }

  void login(String email, String password) async {
    isLoading.value = true;

    try {
      User user = await apiService.login(email, password);

      // Initialisation des controllers
      Get.put(ChatController());
      Get.put(NotificationController());
      Get.put(DemandeTransfertController());
      Get.put(DemandeReorientationController());

      if (user.email == "admin@example.com") {
        Get.offAll(() => AdminHomeScreen());
      } else if (user.email == "teacher@example.com") {
        Get.offAll(() => TeacherHomeScreen());
      } else if (user.email == "student@example.com") {
        Get.offAll(() => StudentHomeScreen());
      }
    } catch (e) {
      Get.snackbar("Erreur", "Identifiants incorrects",
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }
}
