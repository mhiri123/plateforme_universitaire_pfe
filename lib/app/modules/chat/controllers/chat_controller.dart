import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../models/message.dart';

class ChatController extends GetxController {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter();
  var messages = <Message>[].obs;
  final TextEditingController messageController = TextEditingController();

  // Nouveau : compteur de messages non lus
  var unreadCount = 0.obs;

  // Récupération dynamique des infos utilisateur connecté
  final box = GetStorage();

  late final String currentUserId;
  late final String currentUserName;
  late final String currentUserRole;

  // À renseigner dynamiquement selon la conversation (doit être mis à jour avant d'ouvrir le chat)
  String receiverId = "";
  String receiverName = "";
  String receiverRole = "";

  @override
  void onInit() {
    super.onInit();
    currentUserId = box.read('userId') ?? "1";
    currentUserName = box.read('userName') ?? "Utilisateur";
    currentUserRole = box.read('userRole') ?? "Étudiant";
    initPusher();
  }

  Future<void> initPusher() async {
    try {
      await pusher.init(
        apiKey: "132bda35003d903c26a2",
        cluster: "mt1",
      );

      await pusher.subscribe(channelName: "chat.$currentUserId");
      await pusher.connect();

      if (currentUserRole.toLowerCase() == "admin" || currentUserRole.toLowerCase() == "administrateur") {
        await pusher.subscribe(channelName: "chat.admin");
      }

      pusher.onEvent = (event) {
        print("Event reçu : ${event.eventName} / ${event.data}");
        if (event.eventName == "mon-événement") {
          if (event.data != null) {
            dynamic data;
            try {
              data = event.data is String
                  ? json.decode(event.data!)
                  : Map<String, dynamic>.from(event.data as Map);
              print("Données traitées : $data");
            } catch (e) {
              print("Erreur lors du décodage des données: $e");
              return;
            }
            // Affiche le message si l'utilisateur est concerné
            if (data['sender_id'].toString() == currentUserId ||
                data['receiver_id'].toString() == currentUserId ||
                currentUserRole.toLowerCase() == "admin" ||
                currentUserRole.toLowerCase() == "administrateur") {
              final message = Message.fromJson(data);
              messages.add(message);

              // Incrémente le compteur si le message est reçu (pas envoyé par soi-même)
              if (data['sender_id'].toString() != currentUserId) {
                unreadCount.value++;
              }
            }
          }
        }
      };
    } catch (e) {
      print('Erreur lors de l\'initialisation de Pusher: $e');
      Get.snackbar('Erreur Pusher', e.toString());
    }
  }

  // Remettre à zéro le compteur de messages non lus (à appeler quand on ouvre le chat)
  void resetUnread() {
    unreadCount.value = 0;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      // Vérifie que receiverId est bien renseigné
      if (receiverId.isEmpty) {
        Get.snackbar('Erreur', 'Aucun destinataire sélectionné');
        return;
      }

      final message = Message(
        text: text,
        senderId: currentUserId,
        senderName: currentUserName,
        senderRole: currentUserRole,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverRole: receiverRole,
        time: DateTime.now(),
      );

      final response = await http.post(
        Uri.parse('http://192.168.1.17:8000/api/send-message'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message.toJson()),
      );

      if (response.statusCode == 200) {
        messageController.clear();
        Get.snackbar('Succès', 'Message envoyé avec succès');
        // Optionnel : Ajout local immédiat (optimistic update)
        // messages.add(message);
      } else {
        final errorData = json.decode(response.body);
        print('Erreur: ${response.statusCode}');
        Get.snackbar('Erreur', errorData['message'] ?? 'Échec de l\'envoi du message.');
      }
    } catch (e) {
      print('Erreur HTTP: $e');
      Get.snackbar('Erreur Réseau', e.toString());
    }
  }
}