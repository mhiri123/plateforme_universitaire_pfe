import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/homestudent_controller.dart';
import '../../../routes/app_pages.dart';

import '../../chat/views/chat_view.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../chat/controllers/chat_controller.dart';

class HomestudentView extends GetView<HomestudentController> {
  const HomestudentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: const Color(0xFF4B3F72),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/avatar.jpeg')),
                const SizedBox(height: 30),
                sideNavItem("Accueil", Icons.dashboard, Routes.HOMESTUDENT),
                sideNavItem("Mes Demandes", Icons.assignment, Routes.MESDEMANDES),
                sideNavItem("Chat", Icons.chat_bubble_outline, Routes.CHAT),
                sideNavItem("Transfert", Icons.swap_horiz, Routes.DEMANDETRANSFERT),
                sideNavItem("Réorientation", Icons.compare_arrows, Routes.DEMANDEREO),
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
                // Header fixé
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Salut, Étudiant 👋",
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
                              chatController.receiverId = "2"; // ID de l'enseignant référent
                              chatController.receiverName = "Sami Enseignant";
                              chatController.receiverRole = "Enseignant";
                              chatController.resetUnread(); // Remettre le badge à zéro
                              Get.to(() => ChatScreen());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none, size: 28),
                            tooltip: 'Notifications',
                            onPressed: () {
                              Get.toNamed(Routes.NOTIFICATION);
                            },
                          ),
                          const SizedBox(width: 10),
                          const CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.jpeg')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contenu scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bienvenue sur votre espace étudiant",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 30),

                        // Stat Cards
                        Row(
                          children: [
                            Expanded(
                              child: HoverCard(
                                title: "Transferts",
                                color: Colors.pinkAccent,
                                onTap: () => Get.toNamed(Routes.DEMANDETRANSFERT),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: HoverCard(
                                title: "Réorientations",
                                color: Colors.blueAccent,
                                onTap: () => Get.toNamed(Routes.DEMANDEREO),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: HoverCard(
                                title: "Mes Demandes",
                                color: Colors.greenAccent,
                                onTap: () => Get.toNamed(Routes.MESDEMANDES),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(child: Container()), // Espace vide pour maintenir la mise en page
                          ],
                        ),
                      ],
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

  // Sidebar avec badge sur l'icône chat
  Widget sideNavItem(String title, IconData icon, String route) {
    final chatController = Get.find<ChatController>();
    return InkWell(
      onTap: () {
        if (title == "Chat") {
          chatController.receiverId = "2"; // ID de l'enseignant référent
          chatController.receiverName = "Sami Enseignant";
          chatController.receiverRole = "Enseignant";
          chatController.resetUnread(); // Remettre le badge à zéro
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
}

// === HoverCard ===
class HoverCard extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const HoverCard({
    Key? key, 
    required this.title, 
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: isHovered ? (Matrix4.identity()..scale(1.03)) : Matrix4.identity(),
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(isHovered ? 0.4 : 0.2),
              blurRadius: isHovered ? 12 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHovered ? widget.color.withOpacity(0.9) : widget.color,
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shadowColor: widget.color.withOpacity(0.4),
                ),
                child: Text(
                  widget.title == "Mes Demandes" ? "Voir mes demandes" : "Soumettre une demande",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}