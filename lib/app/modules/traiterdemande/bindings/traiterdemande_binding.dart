import 'package:get/get.dart';

import '../controllers/traiterdemande_controller.dart';

class TraiterdemandeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraiterdemandeController>(
      () => TraiterdemandeController(),
    );
  }
}
