import 'package:get/get.dart';
import '../../../models/request_model.dart';

class RequestManagementController extends GetxController {
  var requests = <Request>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRequests();
  }

  void _loadRequests() {
    requests.addAll([
      Request(id: 1, type: "Réorientation", status: "En attente"),
      Request(id: 2, type: "Transfert", status: "En attente"),
      Request(id: 3, type: "Réorientation", status: "Approuvée"),
    ]);
  }

  void approveRequest(int id) {
    int index = requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      requests[index] = requests[index].copyWith(status: "Approuvée");
    }
  }

  void rejectRequest(int id) {
    int index = requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      requests[index] = requests[index].copyWith(status: "Rejetée");
    }
  }

  void deleteRequest(int id) {
    requests.removeWhere((r) => r.id == id);
  }

  void addRequest(Request request) {
    requests.add(request);
  }
}
