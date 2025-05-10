import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../../../models/message.dart';
import '../../../routes/app_pages.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatScreen({Key? key}) : super(key: key);

  void goToHome() {
    final role = controller.currentUserRole.toLowerCase();
    if (role == "admin" || role == "administrateur") {
      Get.offAllNamed(Routes.HOMEADMIN);
    } else if (role == "enseignant") {
      Get.offAllNamed(Routes.HOMETEACHER);
    } else if (role == "étudiant" || role == "etudiant") {
      Get.offAllNamed(Routes.HOMESTUDENT);
    } else {
      Get.offAllNamed(Routes.HOMESTUDENT);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String role = controller.currentUserRole;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(role),
          Expanded(
            child: Column(
              children: [
                Divider(height: 1),
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      reverse: true,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[controller.messages.length - 1 - index];
                        final isMe = message.senderId == controller.currentUserId;
                        return _buildMessageBubble(message, isMe);
                      },
                    );
                  }),
                ),
                Divider(height: 1),
                _buildMessageInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ HEADER (haut de page)
  Widget _buildHeader(String role) {
    String title = "Messagerie";
    if (role.toLowerCase().contains("admin")) {
      title = "Messagerie administrateur";
    } else if (role.toLowerCase() == "enseignant") {
      title = "Messagerie enseignant";
    } else if (role.toLowerCase().contains("étudiant") || role.toLowerCase().contains("etudiant")) {
      title = "Messagerie étudiant";
    }

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: Colors.blueAccent, size: 28),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 16,
                        child: Text(
                          controller.receiverName.isNotEmpty
                              ? controller.receiverName[0].toUpperCase()
                              : "U",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.receiverName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(controller.receiverRole, style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 28, color: Colors.blueAccent),
                tooltip: 'Accueil',
                onPressed: goToHome,
              ),
              IconButton(
                icon: Icon(Icons.notifications_none, size: 28),
                tooltip: 'Notifications',
                onPressed: () => Get.toNamed(Routes.NOTIFICATION),
              ),
              SizedBox(width: 10),
              CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.jpeg')),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Message Bubble
  Widget _buildMessageBubble(Message message, bool isMe) {
    final time = "${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueGrey[200],
              child: Text(message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : "U",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          if (!isMe) SizedBox(width: 8),
          Flexible(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: isMe ? Radius.circular(18) : Radius.circular(4),
                  bottomRight: isMe ? Radius.circular(4) : Radius.circular(18),
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      "${message.senderName} (${message.senderRole})",
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w600),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: isMe ? Colors.white70 : Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent,
              child: Text(message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : "U",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  /// ✅ Input Message Box
  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Écrire un message...',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 48,
              width: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.blueAccent,
                  elevation: 3,
                ),
                onPressed: () {
                  controller.sendMessage(controller.messageController.text);
                },
                child: Icon(Icons.send, size: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
