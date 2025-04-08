import 'package:get/get.dart';

import '../controllers/request_management_controller.dart';

class RequestManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestManagementController>(
      () => RequestManagementController(),
    );
  }
}
