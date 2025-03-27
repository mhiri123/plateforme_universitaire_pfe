import 'package:get/get.dart';

import '../controllers/demandereo_controller.dart';

class DemandereoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandeReorientationController>(
      () => DemandeReorientationController(),
    );
  }
}
