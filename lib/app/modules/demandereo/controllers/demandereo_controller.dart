import 'package:get/get.dart';

class ReorientationController extends GetxController {
  var demandesReo = [].obs;

  void ajouterDemandeReo(String demande) {
    demandesReo.add(demande);
    update();
  }

  void supprimerDemandeReo(int index) {
    demandesReo.removeAt(index);
    update();
  }
}
