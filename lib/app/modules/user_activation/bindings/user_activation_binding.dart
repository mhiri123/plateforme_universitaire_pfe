import 'package:get/get.dart';

import '../controllers/user_activation_controller.dart';

class UserActivationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserActivationController>(
      () => UserActivationController(),
    );
  }
}
