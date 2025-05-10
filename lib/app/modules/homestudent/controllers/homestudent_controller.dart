import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demande_reorientation_controller.dart';

import '../../demandetransfert_etudiant/controllers/demandetransfertenseignant_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class StudentHomeController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());
  final DemandeTransfertEtudiantController demandeTransfertController = Get.put(DemandeTransfertEtudiantController());

// Ajoutez ici des méthodes si l'étudiant peut voir ses demandes soumises, etc.
}

