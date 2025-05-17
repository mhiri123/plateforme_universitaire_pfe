// screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../../../models/notification_model.dart' as models;
import 'package:timeago/timeago.dart' as timeago;

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tout marquer comme lu',
            onPressed: () => controller.marquerToutCommeLues(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () => controller.chargerNotifications(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.chargerNotifications(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Aucune notification',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return NotificationCard(
              notification: notification,
              onTap: () => controller.marquerCommeLue(notification.id!),
              onDelete: () => controller.supprimerNotification(notification.id!),
            );
          },
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final models.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForType(notification.type ?? 'default'),
                    color: (notification.isRead ?? false) ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notification.titre ?? 'Sans titre',
                      style: TextStyle(
                        fontWeight: notification.isRead != null
                            ? (notification.isRead!
                                ? FontWeight.normal
                                : FontWeight.bold)
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (notification.isRead != null && !(notification.isRead!))
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message ?? 'Pas de contenu',
                style: TextStyle(
                  color: (notification.isRead ?? false) ? Colors.grey : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timeago.format(notification.createdAt ?? DateTime.now(), locale: 'fr'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    if (type.isEmpty) return Icons.notifications;
    switch (type.toLowerCase()) {
      case 'transfert':
        return Icons.swap_horiz;
      case 'reorientation':
        return Icons.change_circle;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}