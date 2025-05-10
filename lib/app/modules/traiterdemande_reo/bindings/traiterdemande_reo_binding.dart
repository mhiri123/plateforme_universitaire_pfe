import 'package:get/get.dart';

import '../controllers/traiterdemande_reo_controller.dart';

class TraiterdemandeReoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TraiterdemandeReoController>(
      () => TraiterdemandeReoController(),
    );
  }
}
