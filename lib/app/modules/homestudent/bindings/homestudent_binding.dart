import 'package:get/get.dart';

import '../controllers/homestudent_controller.dart';

class HomestudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomestudentController>(
      () => HomestudentController(),
    );
  }
}
