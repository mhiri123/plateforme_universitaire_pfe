import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class StudentHomeController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());
  final DemandeTransfertController demandeTransfertController = Get.put(DemandeTransfertController());

// Ajoutez ici des méthodes si l'étudiant peut voir ses demandes soumises, etc.
}

