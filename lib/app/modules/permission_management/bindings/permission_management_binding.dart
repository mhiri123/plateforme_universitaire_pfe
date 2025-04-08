import 'package:get/get.dart';

import '../controllers/permission_management_controller.dart';

class PermissionManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(
      () => PermissionController(),
    );
  }
}
