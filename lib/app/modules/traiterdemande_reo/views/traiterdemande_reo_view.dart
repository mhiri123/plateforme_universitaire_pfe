import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/demande_reorientation_model.dart';
import '../controllers/traiterdemande_reo_controller.dart';

class AdminTraitementDemandeReoScreen extends StatelessWidget {
  final TraiterdemandeReoController controller = Get.put(TraiterdemandeReoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traitement des Demandes de Réorientation'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.demandesEnAttente.isEmpty) {
          return const Center(
            child: Text(
              'Aucune demande en attente',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.demandesEnAttente.length,
          itemBuilder: (context, index) {
            final demande = controller.demandesEnAttente[index];
            return _buildDemandeCard(demande);
          },
        );
      }),
    );
  }

  Widget _buildDemandeCard(DemandeReorientation demande) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${demande.prenom} ${demande.nom}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(demande.statut),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Filière actuelle', demande.filiereActuelleNom),
            _buildInfoRow('Nouvelle filière souhaitée', demande.nouvelleFiliereNom),
            _buildInfoRow('Niveau', demande.level),
            _buildInfoRow('Faculté', demande.facultyName),
            const SizedBox(height: 12),
            const Text(
              'Motivation:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(demande.motivation),
            if (demande.pieceJustificative != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter la visualisation du document
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Voir le document justificatif'),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => controller.traiterDemande(demande, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Refuser'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => controller.traiterDemande(demande, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Accepter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(StatutDemande statut) {
    switch (statut) {
      case StatutDemande.enAttente:
        return Chip(
          label: const Text('En attente'),
          backgroundColor: Colors.orange.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.orange),
        );
      case StatutDemande.acceptee:
        return Chip(
          label: const Text('Acceptée'),
          backgroundColor: Colors.green.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.green),
        );
      case StatutDemande.rejetee:
        return Chip(
          label: const Text('Rejetée'),
          backgroundColor: Colors.red.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.red),
        );
    }
  }
}