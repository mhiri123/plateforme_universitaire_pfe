import 'package:dio/dio.dart';
import '../models/notification.dart';

class NotificationService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.17:8000', // Remplacez par votre URL de base
    connectTimeout: Duration(milliseconds: 5000),  // Connect timeout
    receiveTimeout: Duration(milliseconds: 3000),  // Receive timeout
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Fonction pour récupérer les notifications
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await _dio.get('/api/notifications');
      // Assurez-vous que la clé 'notifications' existe dans la réponse
      if (response.data != null && response.data['notifications'] is List) {
        final List<dynamic> notificationsJson = response.data['notifications'];
        return notificationsJson
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Format de données inattendu pour les notifications');
      }
    } catch (e) {
      // Fournir des détails supplémentaires sur l'erreur
      throw Exception('Erreur lors de la récupération des notifications: $e');
    }
  }

  // Fonction pour obtenir le nombre de notifications non lues
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('/api/notifications/unread-count');
      // Vérifiez si la clé 'unread_count' est présente et a la bonne valeur
      if (response.data != null && response.data['unread_count'] is int) {
        return response.data['unread_count'];
      } else {
        throw Exception('Format de données inattendu pour le nombre de notifications non lues');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du nombre de notifications non lues: $e');
    }
  }

  // Fonction pour marquer une notification comme lue
  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _dio.post('/api/notifications/$notificationId/read');
      // Vous pouvez vérifier le code de statut de la réponse si nécessaire
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour de la notification');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la notification: $e');
    }
  }

  // Fonction pour marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    try {
      final response = await _dio.post('/api/notifications/mark-all-read');
      // Vous pouvez vérifier le code de statut de la réponse si nécessaire
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour de toutes les notifications');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de toutes les notifications: $e');
    }
  }
}
