import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/message.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        return Column(
          children: [
            // Affichage de la liste des messages
            Expanded(
              child: ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  Message message = chatController.messages[index];
                  return ListTile(
                    title: Text(message.text),
                    subtitle: Text(message.sender),
                    trailing: Text(
                      "${message.time.hour}:${message.time.minute}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                  );
                },
              ),
            ),
            // Champ de texte pour envoyer un message
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController.messageController,
                      decoration: InputDecoration(
                        hintText: "Écrire un message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Passer le texte du message à la méthode sendMessage
                      String messageText = chatController.messageController.text;
                      chatController.sendMessage(messageText);  // Passer le texte ici
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
