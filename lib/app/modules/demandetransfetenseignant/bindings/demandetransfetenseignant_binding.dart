import 'package:get/get.dart';

import '../controllers/demandetransfetenseignant_controller.dart';

class DemandetransfetenseignantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandeTransfertEnseignantController>(
      () => DemandeTransfertEnseignantController(),
    );
  }
}
