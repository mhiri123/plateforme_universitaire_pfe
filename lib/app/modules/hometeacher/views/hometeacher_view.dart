import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/controllers/chat_controller.dart';
import '../controllers/hometeacher_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../../services/notification_service.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final ChatController chatController = Get.put(ChatController());
  final NotificationService notificationService = Get.put(NotificationService(
    secureStorage: Get.find<FlutterSecureStorage>(),
  ));
  final NotificationController notificationController = Get.put(NotificationController(Get.find<NotificationService>()));

  final List<bool> _isHovered = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: const Color(0xFF3F3D56),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/enseignant.jpg')),
                const SizedBox(height: 30),
                sideNavItem("Accueil", Icons.dashboard, Routes.HOMETEACHER),
                sideNavItem("Chat", Icons.chat_bubble_outline, Routes.CHAT),
                sideNavItem("Transfert", Icons.swap_horiz, Routes.DEMANDETRANSFETENSEIGNANT),
                sideNavItem("Notifications", Icons.notifications, Routes.NOTIFICATION),
                const Spacer(),
                sideNavItem("Déconnexion", Icons.logout, Routes.LOGIN),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bienvenue, Enseignant 👨‍🏫",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Obx(() => Stack(
                              children: [
                                const Icon(Icons.chat_bubble_outline, size: 26),
                                if (chatController.unreadCount.value > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${chatController.unreadCount.value}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                            tooltip: 'Chat',
                            onPressed: () {
                              chatController.receiverId = "1"; // ID de l'étudiant
                              chatController.receiverName = "Ali";
                              chatController.receiverRole = "Étudiant";
                              chatController.resetUnread();
                              Get.to(() => ChatScreen());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none, size: 28),
                            tooltip: 'Notifications',
                            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
                          ),
                          const SizedBox(width: 10),
                          const CircleAvatar(backgroundImage: AssetImage('assets/images/enseignant.jpg')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildHoverCard(
                            index: 0,
                            title: "Demande de Transfert",
                            color: Colors.teal,
                            buttonText: "Soumettre une demande",
                          ),
                          const SizedBox(width: 30),
                          buildHoverCard(
                            index: 1,
                            title: "Messages non lus",
                            color: Colors.blueAccent,
                            messageCount: chatController.unreadCount.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar : initialisation du destinataire pour "Chat" + badge
  Widget sideNavItem(String title, IconData icon, String route) {
    return InkWell(
      onTap: () {
        if (title == "Chat") {
          chatController.receiverId = "1"; // ID de l'étudiant
          chatController.receiverName = "Ali";
          chatController.receiverRole = "Étudiant";
          chatController.resetUnread();
          Get.to(() => ChatScreen());
        } else {
          Get.toNamed(route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            if (title == "Chat")
              Obx(() => Stack(
                children: [
                  Icon(icon, color: Colors.white70),
                  if (chatController.unreadCount.value > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chatController.unreadCount.value}',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ))
            else
              Icon(icon, color: Colors.white70),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Carte dynamique pour "Messages non lus" => ouvre le chat avec l'étudiant
  Widget buildHoverCard({required int index, required String title, required Color color, int messageCount = 0, String buttonText = "Voir les messages"}) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered[index] = true),
      onExit: (_) => setState(() => _isHovered[index] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered[index] ? (Matrix4.identity()..scale(1.03)) : Matrix4.identity(),
        curve: Curves.easeOut,
        height: 200,
        width: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered[index] ? color.withOpacity(0.4) : color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: _isHovered[index] ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            if (messageCount > 0)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "$messageCount Non lus",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (title == "Demande de Transfert") {
                  Get.toNamed(Routes.DEMANDETRANSFETENSEIGNANT);
                } else {
                  chatController.receiverId = "1"; // ID de l'étudiant
                  chatController.receiverName = "Ali";
                  chatController.receiverRole = "Étudiant";
                  chatController.resetUnread();
                  Get.to(() => ChatScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}