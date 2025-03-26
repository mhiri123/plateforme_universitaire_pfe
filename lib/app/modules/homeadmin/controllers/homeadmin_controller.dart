import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class AdminHomeController extends GetxController {
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());
  final DemandeTransfertController demandeTransfertController = Get.put(DemandeTransfertController());
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());

// Logique pour traiter les demandes, chat, notifications
// Ajoutez les méthodes nécessaires pour traiter des demandes, etc.
}
