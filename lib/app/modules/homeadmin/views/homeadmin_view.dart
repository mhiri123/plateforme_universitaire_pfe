import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plateforme_universitaire/app/modules/demandetransfert_etudiant/controllers/demandetransfertenseignant_controller.dart';
import '../../../routes/app_pages.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../chat/views/chat_view.dart';

import '../../demandetransfetenseignant/controllers/demandetransfetenseignant_controller.dart';

import '../../notification/controllers/notification_controller.dart';
import '../../demandereo/controllers/demande_reorientation_controller.dart';

import '../controllers/homeadmin_controller.dart';

class AdminHomeScreen extends StatelessWidget {
  final AdminHomeController adminHomeController = Get.put(AdminHomeController());
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());
  final DemandeTransfertEnseignantController demandeTransfertEnseignantController = Get.put(DemandeTransfertEnseignantController());
  final DemandeTransfertEtudiantController demandeTransfertEtudiantController = Get.put(DemandeTransfertEtudiantController());
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    // Récupération initiale des demandes
    ever(adminHomeController.isLoading, (_) {
      if (!adminHomeController.isLoading.value) {
        adminHomeController.recupererDemandesReorientation();
        adminHomeController.recupererDemandesTransfertEnseignant();
        adminHomeController.recupererDemandesTransfertEtudiant();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F5),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF2E3A59),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/admin.jpeg')),
                const SizedBox(height: 30),
                sideNavItem("Tableau de bord", Icons.dashboard, Routes.HOMEADMIN),

                // Menu déroulant pour les demandes
                ExpansionTile(
                  title: Text("Traiter demandes", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  leading: Icon(Icons.assignment_turned_in, color: Colors.white70),
                  children: [
                    _buildSubNavItem("Traiter demande réorientation", Routes.TRAITERDEMANDE_REO),
                   // _buildSubNavItem("Traiter demande transfert étudiant", Routes.TRAITER_DEMANDE_TRANSFERT_ETUDIANT),
                   // _buildSubNavItem("Traiter demande transfert enseignant", Routes.TRAITER_DEMANDE_TRANSFERT_ENSEIGNANT),
                  ],
                ),

                sideNavItem("Messages", Icons.chat_bubble_outline, Routes.CHAT),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bienvenue, Administrateur 👩‍💻",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Bouton Chat
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
                              chatController.resetUnread();
                              Get.to(() => ChatScreen());
                            },
                          ),
                          // Bouton Notifications
                          IconButton(
                            icon: const Icon(Icons.notifications_none, size: 28),
                            tooltip: 'Notifications',
                            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
                          ),
                          const SizedBox(width: 10),
                          const CircleAvatar(backgroundImage: AssetImage('assets/images/admin.jpeg')),
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
                        const Text("Votre tableau de bord administrateur", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            // Carte Demandes de Réorientation
                            Expanded(
                              child: Obx(() => statCard(
                                  "Demandes de Réorientation",
                                  '${adminHomeController.demandesReorientation.length}',
                                  const Color(0xFF1E88E5)
                              )),
                            ),
                            const SizedBox(width: 20),
                            // Carte Demandes de Transfert Enseignant
                            Expanded(
                              child: Obx(() => statCard(
                                  "Transfert Enseignant",
                                  '${adminHomeController.demandesTransfertEnseignant.length}',
                                  const Color(0xFF43A047)
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Carte Demandes de Transfert Étudiant
                            Expanded(
                              child: Obx(() => statCard(
                                  "Transfert Étudiant",
                                  '${adminHomeController.demandesTransfertEtudiant.length}',
                                  const Color(0xFFF4A460)
                              )),
                            ),
                            const SizedBox(width: 20),
                            // Carte Messages non lus
                            Expanded(
                              child: Obx(() => statCard(
                                "Messages non lus",
                                '${chatController.unreadCount.value}',
                                const Color(0xFF8E24AA),
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Carte Notifications
                            Expanded(
                              child: Obx(() => statCard(
                                  "Notifications",
                                  '${notificationController.notifications.length}',
                                  const Color(0xFFF9A825)
                              )),
                            ),
                            const SizedBox(width: 20),
                            // Carte vide ou supplémentaire si nécessaire
                            Expanded(child: Container()),
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

  // Méthode pour les éléments de navigation
  Widget sideNavItem(String title, IconData icon, String route) {
    final chatController = Get.find<ChatController>();
    return InkWell(
      onTap: () {
        if (title == "Messages") {
          chatController.resetUnread();
          Get.to(() => ChatScreen());
        } else {
          Get.toNamed(route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 3, color: Colors.white.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            if (title == "Messages")
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

  // Méthode pour les sous-éléments de navigation
  Widget _buildSubNavItem(String title, String route) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        onTap: () {
          Get.back(); // Ferme le drawer si nécessaire
          Get.toNamed(route);
        },
      ),
    );
  }

  // Méthode pour les cartes de statistiques
  Widget statCard(String title, String value, Color color) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}