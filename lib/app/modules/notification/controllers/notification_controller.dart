import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = [].obs; // Liste des notifications

  void envoyerNotification(String titre, String message) {
    notifications.add({"titre": titre, "message": message});
    Get.snackbar("Notification envoyée", "Le message a été transmis.");
  }
}
