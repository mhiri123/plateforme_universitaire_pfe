import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../demandetransfetenseignant/controllers/demandetransfetenseignant_controller.dart';
import '../../../services/notification_service.dart';
import '../../notification/controllers/notification_controller.dart';

class TeacherHomeController extends GetxController {
  final ChatController chatController = Get.put(ChatController());
  final NotificationService notificationService = Get.put(NotificationService(
    secureStorage: Get.find<FlutterSecureStorage>(),
  ));
  final NotificationController notificationController = Get.put(NotificationController(Get.find<NotificationService>()));
  final DemandeTransfertEnseignantController demandeTransfertController = Get.put(DemandeTransfertEnseignantController());

  @override
  void onInit() {
    super.onInit();
  }
}
