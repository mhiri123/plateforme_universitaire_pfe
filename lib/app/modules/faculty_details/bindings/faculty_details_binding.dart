import 'package:get/get.dart';

import '../controllers/faculty_details_controller.dart';

class FacultyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacultyController>(
      () => FacultyController(),
    );
  }
}
