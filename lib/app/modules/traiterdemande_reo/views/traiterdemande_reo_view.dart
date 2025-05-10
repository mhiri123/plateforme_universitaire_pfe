import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../services/demande_reorientation_service.dart';

import '../../demandereo/controllers/demande_reorientation_controller.dart';

class AdminTraitementDemandeReoScreen extends StatelessWidget {
  // Utilisez Get.put() pour initialiser le contrôleur s'il n'existe pas
  final DemandeReorientationController controller =
  Get.put(DemandeReorientationController());

  @override
  Widget build(BuildContext context) {
    // Chargez les demandes en attente dès l'initialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.chargerDemandesEnAttente();
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Gestion des Demandes de Réorientation'),
      backgroundColor: Colors.indigo[800],
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => controller.chargerDemandesEnAttente(),
          tooltip: 'Actualiser les demandes',
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: _showFiltresDialog,
          tooltip: 'Filtrer les demandes',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      // Affichage des messages d'erreur
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorState();
      }

      // État de chargement
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      // Liste vide
      if (controller.demandesEnAttente.isEmpty) {
        return _buildEmptyState();
      }

      // Liste des demandes
      return _buildDemandesListView();
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100
          ),
          SizedBox(height: 20),
          Text(
            'Erreur de chargement',
            style: TextStyle(
                fontSize: 18,
                color: Colors.red
            ),
          ),
          SizedBox(height: 10),
          Text(
            controller.errorMessage.value,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => controller.chargerDemandesEnAttente(),
            icon: Icon(Icons.refresh),
            label: Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[700],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              Icons.inbox_outlined,
              size: 100,
              color: Colors.grey[300]
          ),
          SizedBox(height: 20),
          Text(
            'Aucune demande de réorientation en attente',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600]
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => controller.chargerDemandesEnAttente(),
            icon: Icon(Icons.refresh),
            label: Text('Actualiser'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[700],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDemandesListView() {
    return ListView.separated(
      itemCount: controller.demandesEnAttente.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final demande = controller.demandesEnAttente[index];
        return _buildDemandeListTile(demande);
      },
    );
  }

  Widget _buildDemandeListTile(DemandeReorientation demande) {
    return ListTile(
      title: Text(
          '${demande.nom} ${demande.prenom}',
          style: TextStyle(fontWeight: FontWeight.bold)
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'De ${demande.filiereActuelleNom} vers ${demande.nouvelleFiliereNom}',
            style: TextStyle(color: Colors.grey[700]),
          ),
          Text(
            'Déposée le ${DateFormat('dd/MM/yyyy HH:mm').format(demande.dateCreation!)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.green),
            onPressed: () => _showTraitementDialog(demande, true),
            tooltip: 'Accepter la demande',
          ),
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.red),
            onPressed: () => _showTraitementDialog(demande, false),
            tooltip: 'Rejeter la demande',
          ),
        ],
      ),
      onTap: () => _showDetailsDialog(demande),
    );
  }

  void _showDetailsDialog(DemandeReorientation demande) {
    Get.dialog(
      AlertDialog(
        title: Text('Détails de la Demande'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Nom', demande.nom),
              _buildDetailRow('Prénom', demande.prenom),
              _buildDetailRow('Filière Actuelle', demande.filiereActuelleNom),
              _buildDetailRow('Nouvelle Filière', demande.nouvelleFiliereNom),
              _buildDetailRow('Motivation', demande.motivation),
              _buildDetailRow('Date de Création',
                  DateFormat('dd/MM/yyyy HH:mm').format(demande.dateCreation!)
              ),
              if (demande.pieceJustificative != null)
                _buildPieceJustificativeSection(demande),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPieceJustificativeSection(DemandeReorientation demande) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pièce justificative jointe',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.blue),
            onPressed: () {
              // TODO: Implémenter la logique de visualisation du fichier
              Get.snackbar(
                'Pièce Justificative',
                'Fonctionnalité de visualisation à implémenter',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTraitementDialog(DemandeReorientation demande, bool isAccepted) {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmation de Traitement'),
        content: Text(
            isAccepted
                ? 'Voulez-vous accepter cette demande de réorientation ?'
                : 'Voulez-vous rejeter cette demande de réorientation ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _traiterDemande(demande, isAccepted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccepted ? Colors.green : Colors.red,
            ),
            child: Text(isAccepted ? 'Accepter' : 'Rejeter'),
          ),
        ],
      ),
    );
  }

  void _traiterDemande(DemandeReorientation demande, bool isAccepted) {
    controller.traiterDemandeReorientation(
      demande: demande,
      accepter: isAccepted, // Correction ici : remplacer 'isAccepted' par 'accepter'
    );
  }

  void _showFiltresDialog() {
    // État pour les filtres
    final RxBool filtreFiliere = false.obs;
    final RxBool filtreDate = false.obs;

    Get.dialog(
      AlertDialog(
        title: Text('Filtres des Demandes'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Filières spécifiques'),
              value: filtreFiliere.value,
              onChanged: (bool? value) => filtreFiliere.value = value ?? false,
            ),
            CheckboxListTile(
              title: Text('Date de création'),
              value: filtreDate.value,
              onChanged: (bool? value) => filtreDate.value = value ?? false,
            ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la logique de filtrage
              Get.back();
              Get.snackbar(
                'Filtres',
                'Fonctionnalité de filtrage à implémenter',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Appliquer'),
          ),
        ],
      ),
    );
  }
}