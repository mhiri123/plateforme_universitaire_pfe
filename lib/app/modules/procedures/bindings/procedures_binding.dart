import 'package:get/get.dart';

import '../controllers/procedures_controller.dart';

class ProceduresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProceduresController>(
      () => ProceduresController(),
    );
  }
}
