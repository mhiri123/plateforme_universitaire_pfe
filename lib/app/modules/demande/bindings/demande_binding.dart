import 'package:get/get.dart';

import '../controllers/demande_controller.dart';

class DemandeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandeController>(
      () => DemandeController(),
    );
  }
}
