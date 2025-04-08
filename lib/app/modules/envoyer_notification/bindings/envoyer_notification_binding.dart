import 'package:get/get.dart';

import '../controllers/envoyer_notification_controller.dart';

class EnvoyerNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
