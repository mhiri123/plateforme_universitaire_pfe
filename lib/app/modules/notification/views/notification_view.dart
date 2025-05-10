// screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/notification.dart';

import '../controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _controller = NotificationController();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _notifications = await _controller.fetchNotifications() as List<NotificationModel>;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement des notifications')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  IconData _getIconByType(NotificationType type) {
    switch (type) {
      case NotificationType.demandeReorientation:
        return Icons.swap_horiz;
      case NotificationType.statutDemande:
        return Icons.check_circle_outline;
      case NotificationType.messageSysteme:
        return Icons.info_outline;
      case NotificationType.rappel:
        return Icons.notifications_active;
      default:
        return Icons.mail_outline;
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    try {
      await _controller.markAsRead(notification.id);
      setState(() {
        notification.isRead = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de marquer comme lu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(child: Text('Aucune notification'))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return ListTile(
            leading: Icon(
              _getIconByType(notification.type),
              color: notification.isRead ? Colors.grey : Colors.blue,
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isRead
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.message),
                SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(notification.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            trailing: !notification.isRead
                ? IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () => _markAsRead(notification),
            )
                : null,
          );
        },
      ),
    );
  }
}