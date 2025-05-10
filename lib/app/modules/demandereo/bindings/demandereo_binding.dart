import 'package:get/get.dart';

import '../controllers/demande_reorientation_controller.dart';

class DemandereoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandeReorientationController>(
      () => DemandeReorientationController (),
    );
  }
}
