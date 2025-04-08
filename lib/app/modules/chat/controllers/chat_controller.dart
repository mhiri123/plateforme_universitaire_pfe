import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/message.dart';


class ChatController extends GetxController {
  // Liste des messages dans le chat
  var messages = <Message>[].obs;

  // Contrôleur pour le champ de texte
  final TextEditingController messageController = TextEditingController();

  // Fonction pour envoyer un message
  void sendMessage(String message) {
    String messageText = messageController.text.trim();

    if (messageText.isNotEmpty) {
      // Ajouter le message à la liste des messages
      messages.add(Message(
        text: messageText,
        sender: "Étudiant",  // Peut être dynamique en fonction de l'utilisateur
        time: DateTime.now(),
      ));

      // Effacer le champ de texte après l'envoi
      messageController.clear();
    }
  }
}
