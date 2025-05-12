import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mesdemandes_controller.dart';
import '../../../models/demande_reorientation_model.dart';

class MesdemandesView extends GetView<MesdemandesController> {
  const MesdemandesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F5),
      appBar: AppBar(
        title: const Text('Mes Demandes de Réorientation'),
        backgroundColor: const Color(0xFF2E3A59),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.actualiserDonnees(),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: ${controller.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.actualiserDonnees(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (controller.mesDemandes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Aucune demande de réorientation',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.chargerMesDemandes(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.mesDemandes.length,
            itemBuilder: (context, index) {
              final demande = controller.mesDemandes[index];
              return _buildDemandeCard(demande);
            },
          ),
        );
      }),
    );
  }

  Widget _buildDemandeCard(DemandeReorientation demande) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${demande.prenom} ${demande.nom}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Niveau: ${demande.level}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatutChip(demande.statut),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Filière actuelle', demande.filiereActuelleNom),
            const SizedBox(height: 8),
            _buildInfoRow('Nouvelle filière', demande.nouvelleFiliereNom),
            const SizedBox(height: 8),
            _buildInfoRow('Faculté', demande.facultyName),
            if (demande.commentaireAdmin != null && demande.commentaireAdmin!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRow('Commentaire', demande.commentaireAdmin!),
            ],
            if (demande.dateTraitement != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Date de traitement',
                demande.dateTraitement!.toString().split('.')[0].replaceAll('T', ' '),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatutChip(StatutDemande statut) {
    final color = controller.getStatutColor(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        controller.getStatutLibelle(statut),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
} 