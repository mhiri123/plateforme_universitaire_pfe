import 'package:get/get.dart';

import '../controllers/demandetransfert_controller.dart';

class DemandetransfertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandetransfertController>(
      () => DemandetransfertController(),
    );
  }
}
