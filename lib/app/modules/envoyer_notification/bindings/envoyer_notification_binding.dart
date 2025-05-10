import 'package:get/get.dart';

import '../controllers/notification_sender_controller.dart';

class EnvoyerNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationSenderController>(
      () => NotificationSenderController(),
    );
  }
}
