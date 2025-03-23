import 'package:get/get.dart';

class StudentHomeController extends GetxController {
  void viewReorientationRequests() {
    Get.toNamed('/reorientation_requests');
  }

  void viewTransferRequests() {
    Get.toNamed('/transfer_requests');
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
