import 'package:get/get.dart';

import '../controllers/demandetransfertenseignant_controller.dart';

class DemandetransfertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandeTransfertEtudiantController>(
      () => DemandeTransfertEtudiantController(),
    );
  }
}
