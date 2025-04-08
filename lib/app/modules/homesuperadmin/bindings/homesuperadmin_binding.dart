import 'package:get/get.dart';

import '../controllers/homesuperadmin_controller.dart';

class HomesuperadminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperAdminHomeController>(
      () => SuperAdminHomeController(),
    );
  }
}
