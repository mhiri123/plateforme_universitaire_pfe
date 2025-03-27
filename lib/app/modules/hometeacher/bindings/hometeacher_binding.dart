import 'package:get/get.dart';

import '../controllers/hometeacher_controller.dart';

class HometeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherHomeController >(
      () => TeacherHomeController (),
    );
  }
}
