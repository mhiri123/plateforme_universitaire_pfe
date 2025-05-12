import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demande_reorientation_controller.dart';

import '../../demandetransfert_etudiant/controllers/demandetransfertenseignant_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../../services/notification_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentHomeController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final NotificationService notificationService = Get.put(NotificationService(
    secureStorage: Get.find<FlutterSecureStorage>(),
  ));
  final NotificationController notificationController = Get.put(NotificationController(Get.find<NotificationService>()));
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());
  final DemandeTransfertEtudiantController demandeTransfertController = Get.put(DemandeTransfertEtudiantController());

// Ajoutez ici des méthodes si l'étudiant peut voir ses demandes soumises, etc.
}

class HomestudentController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }
}

