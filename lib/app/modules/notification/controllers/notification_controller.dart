// controllers/notification_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide Notification;
import '../../../services/notification_service.dart';
import '../../../models/notification_model.dart' as models;

class NotificationController extends GetxController {
  final NotificationService _notificationService;
  final RxList<models.Notification> notifications = <models.Notification>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool hasServerError = false.obs;
  Timer? _refreshTimer;
  int _retryCount = 0;
  static const int MAX_RETRIES = 3;

  NotificationController(this._notificationService);

  @override
  void onInit() {
    super.onInit();
    chargerNotifications();
    // Configuration d'un timer pour rafraîchir les notifications périodiquement
    // Délais adaptatif: plus long si des erreurs se produisent
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_retryCount > 0) {
        // Si nous avons eu des erreurs, augmenter l'intervalle
        if (_retryCount >= MAX_RETRIES) {
          timer.cancel();
          _setupRetryMechanism();
          return;
        }
      }
      chargerNotifications(silent: true);
    });
  }

  // Mise en place d'un mécanisme de réessai avec délai exponentiel
  void _setupRetryMechanism() {
    final int delaySeconds = _retryCount * 30; // 30s, 60s, 90s, etc.

    print('Mise en place d\'un réessai dans $delaySeconds secondes');
    Future.delayed(Duration(seconds: delaySeconds), () {
      chargerNotifications(silent: false, isRetry: true);
      // Si ça fonctionne, on remet un timer normal
      if (!hasServerError.value) {
        _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          chargerNotifications(silent: true);
        });
        _retryCount = 0;
      } else if (_retryCount < 5) {
        // Sinon, on réessaie encore avec un délai plus long
        _setupRetryMechanism();
      }
    });
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> chargerNotifications(
      {bool silent = false, bool isRetry = false}) async {
    try {
      if (!silent) isLoading.value = true;
      error.value = '';
      hasServerError.value = false;

      print('Chargement des notifications${isRetry ? " (réessai)" : ""}...');
      final result = await _notificationService.listerNotifications();

      // Réinitialiser le compte de réessais si ça fonctionne
      if (isRetry && result.isNotEmpty) {
        _retryCount = 0;
      }

      // Vérifier si de nouvelles notifications sont arrivées
      if (result.isNotEmpty && notifications.isNotEmpty) {
        final lastNotificationId = notifications.first.id;
        final newNotifications =
            result.where((n) => n.id! > (lastNotificationId ?? 0)).toList();

        if (newNotifications.isNotEmpty && !silent) {
          Get.snackbar(
            'Nouvelles notifications',
            'Vous avez ${newNotifications.length} nouvelle(s) notification(s)',
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }

      notifications.value = result;
    } catch (e) {
      _retryCount++;

      // Gérer différemment les erreurs serveur
      if (e.toString().contains('500') || e.toString().contains('serveur')) {
        hasServerError.value = true;
        error.value =
            'Le service de notification est temporairement indisponible.\nRéessai automatique dans quelques instants...';
        print('❌ Erreur serveur de notifications: $e');
      } else {
        error.value = 'Erreur lors du chargement des notifications: $e';
        print('❌ Erreur général de notification: $e');
      }

      // Si c'est une erreur silencieuse et que c'est la première, afficher quand même
      if (silent && _retryCount <= 1) {
        Get.snackbar(
          'Erreur de notification',
          'Impossible de récupérer vos notifications. Réessai en cours...',
          backgroundColor: Colors.amber,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  Future<void> chargerNotificationsNonLues() async {
    try {
      isLoading.value = true;
      error.value = '';
      hasServerError.value = false;

      final result = await _notificationService.listerNotificationsNonLues();
      notifications.value = result;
    } catch (e) {
      if (e.toString().contains('500') || e.toString().contains('serveur')) {
        hasServerError.value = true;
        error.value =
            'Le service de notification est temporairement indisponible.\nRéessai automatique en cours...';
      } else {
        error.value =
            'Erreur lors du chargement des notifications non lues: $e';
      }
      print('❌ $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour forcer un rafraîchissement manuel
  Future<void> rafraichirNotifications() async {
    // Réinitialiser les compteurs et erreurs
    _retryCount = 0;
    hasServerError.value = false;
    error.value = '';

    await chargerNotifications(silent: false);

    // Si le chargement a échoué mais que le timer a été annulé
    if (hasServerError.value && _refreshTimer == null) {
      _setupRetryMechanism();
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
      notifications.value =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
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

  // Getter pour le nombre de notifications non lues
  int get unreadCount => notifications.where((n) => !(n.isRead)).length;
}
