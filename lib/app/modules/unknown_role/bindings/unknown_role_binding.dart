import 'package:get/get.dart';

import '../controllers/unknown_role_controller.dart';

class UnknownRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnknownRoleController>(
      () => UnknownRoleController(),
    );
  }
}
