// controllers/notification_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide Notification;
import '../../../services/notification_service.dart';
import '../../../models/notification_model.dart' as models;

class NotificationController extends GetxController {
  final NotificationService _notificationService;
  final RxList<models.Notification> notifications = <models.Notification>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  NotificationController(this._notificationService);

  @override
  void onInit() {
    super.onInit();
    chargerNotifications();
  }

  Future<void> chargerNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _notificationService.listerNotifications();
      notifications.value = result;
    } catch (e) {
      error.value = 'Erreur lors du chargement des notifications: $e';
      print('❌ $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> chargerNotificationsNonLues() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _notificationService.listerNotificationsNonLues();
      notifications.value = result;
    } catch (e) {
      error.value = 'Erreur lors du chargement des notifications non lues: $e';
      print('❌ $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> marquerCommeLue(int id) async {
    try {
      error.value = '';
      final notification = await _notificationService.marquerCommeLue(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = notification;
      }
    } catch (e) {
      error.value = 'Erreur lors du marquage de la notification: $e';
      print('❌ $error');
    }
  }

  Future<void> marquerToutCommeLues() async {
    try {
      error.value = '';
      await _notificationService.marquerToutCommeLues();
      // Mettre à jour toutes les notifications comme lues
      notifications.value = notifications.map((n) => n.copyWith(isRead: true)).toList();
      Get.snackbar(
        'Succès',
        'Toutes les notifications ont été marquées comme lues',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = 'Erreur lors du marquage de toutes les notifications: $e';
      print('❌ $error');
      Get.snackbar(
        'Erreur',
        'Impossible de marquer toutes les notifications comme lues',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> supprimerNotification(int id) async {
    try {
      error.value = '';
      await _notificationService.supprimerNotification(id);
      notifications.removeWhere((n) => n.id == id);
      Get.snackbar(
        'Succès',
        'Notification supprimée avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = 'Erreur lors de la suppression de la notification: $e';
      print('❌ $error');
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer la notification',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> creerNotification({
    required String type,
    required int destinataireId,
    required String titre,
    required String message,
  }) async {
    try {
      error.value = '';
      final notification = await _notificationService.creerNotification(
        type: type,
        destinataireId: destinataireId,
        titre: titre,
        message: message,
      );
      notifications.insert(0, notification);
    } catch (e) {
      error.value = 'Erreur lors de la création de la notification: $e';
      print('❌ $error');
    }
  }
}