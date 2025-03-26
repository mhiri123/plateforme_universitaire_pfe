import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class TeacherHomeController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final DemandeTransfertController demandeTransfertController = Get.put(DemandeTransfertController());
}
