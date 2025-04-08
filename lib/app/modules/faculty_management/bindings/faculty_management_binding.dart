import 'package:get/get.dart';

import '../controllers/faculty_management_controller.dart';

class FacultyManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacultyController>(
      () =>FacultyController(),
    );
  }
}
