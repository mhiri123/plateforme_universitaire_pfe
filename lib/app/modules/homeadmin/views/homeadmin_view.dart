import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../chat/views/chat_view.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../notification/views/notification_view.dart';
import '../../traiterdemande/views/traiterdemande_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  final DemandeReorientationController demandeReorientationController =
  Get.put(DemandeReorientationController());
  final DemandeTransfertController demandeTransfertController =
  Get.put(DemandeTransfertController());
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController =
  Get.put(NotificationController());

  void _logout() async {
    // Ajoutez ici votre logique de déconnexion
    // Par exemple: effacer le token, vider le cache, etc.

    // Afficher une boîte de dialogue de confirmation
    Get.defaultDialog(
      title: "Déconnexion",
      middleText: "Êtes-vous sûr de vouloir vous déconnecter?",
      textConfirm: "Oui",
      textCancel: "Non",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Fermer la boîte de dialogue
        // Effectuer la déconnexion et rediriger vers l'écran de connexion
        Get.offAllNamed('/login'); // Remplacez '/login' par votre route de connexion
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tableau de bord Administrateur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'profile') {
                // Navigation vers le profil
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Mon profil'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Déconnexion'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestion des demandes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'Demandes de réorientation',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Gérer les demandes en attente'),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.assignment, color: Colors.blue[800]),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => TraiterDemandeScreen(demandeType: 'Réorientation'));
                },
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'Demandes de transfert',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Gérer les demandes en attente'),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.transfer_within_a_station, color: Colors.green[800]),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => TraiterDemandeScreen(demandeType: 'Transfert'));
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Communication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'Messagerie',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Communiquer avec les utilisateurs'),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chat, color: Colors.purple[800]),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => ChatScreen());
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Alertes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Voir les dernières alertes'),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications, color: Colors.orange[800]),
                ),
                trailing: Badge(
                  child: Icon(Icons.arrow_forward_ios, size: 16),
                  value: '3', // Remplacez par le nombre réel de notifications
                ),
                onTap: () {
                  Get.to(() => NotificationScreen());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          // Action de rafraîchissement
        },
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const Badge({
    required this.child,
    required this.value,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}