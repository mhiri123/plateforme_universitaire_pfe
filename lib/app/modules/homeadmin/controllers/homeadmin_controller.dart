import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';
import '../../notification/controllers/notification_controller.dart';

class AdminHomeController extends GetxController {
  // Controllers initialization using Get.lazyPut
  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => DemandeReorientationController());
    Get.lazyPut(() => DemandeTransfertController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => NotificationController());
  }

  final DemandeReorientationController demandeReorientationController = Get.find();
  final DemandeTransfertController demandeTransfertController = Get.find();
  final ChatController chatController = Get.find();
  final NotificationController notificationController = Get.find();

  // Method to handle request submission for reorientation
  void soumettreDemandeReorientation(
      String nom,
      String prenom,
      String numeroEtudiant,
      String dateNaissance,
      String email,
      String telephone,
      String filiereActuelle,
      String anneeEtude,
      String departement,
      String nouvelleFiliere,
      String departementSouhaite,
      String dateChangement,
      String motivation
      ) {
    demandeReorientationController.soumettreDemandeReorientation(
        nom, prenom, numeroEtudiant, dateNaissance, email, telephone,
        filiereActuelle, anneeEtude, departement, nouvelleFiliere,
        departementSouhaite, dateChangement, motivation
    );
  }

  // Method to handle request submission for transfer
  void soumettreDemandeTransfert(
      String statut,
      String nom,
      String prenom,
      String numeroIdentification,
      String dateNaissance,
      String email,
      String telephone,
      String institutActuel,
      String departement,
      String filiere,
      String anneeEtude,
      String discipline,
      String typeContrat,
      String institutDemande,
      String departementDemande,
      String dateTransfert,
      String motivation
      ) {
    demandeTransfertController.soumettreDemandeTransfert(
        statut, nom, prenom, numeroIdentification, dateNaissance, email, telephone,
        institutActuel, departement, filiere, anneeEtude, discipline, typeContrat,
        institutDemande, departementDemande, dateTransfert, motivation
    );
  }

  // Method to handle new message in chat
  void envoyerMessageChat(String message) {
    chatController.sendMessage(message);
  }

  // Method to fetch notifications for the admin
  void fetchNotifications() {
    // Appel correct de la méthode envoyerNotification avec les 3 paramètres requis
    notificationController.envoyerNotification(
        "Titre de notification",  // Titre de la notification
        "Contenu de la notification",  // Contenu du message
        "admin@exemple.com"  // Destinataire (exemple : l'email ou le rôle)
    );
  }

// Additional methods can be added for approval, updates, etc.
}
