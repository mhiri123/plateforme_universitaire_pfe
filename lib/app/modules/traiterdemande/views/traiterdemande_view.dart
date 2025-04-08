import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../demandereo/controllers/demandereo_controller.dart';
import '../../demandetransfert/controllers/demandetransfert_controller.dart';

class TraiterDemandeScreen extends StatelessWidget {
  final String demandeType;
  final DemandeReorientationController demandeReorientationController = Get.find();
  final DemandeTransfertController demandeTransfertController = Get.find();

  TraiterDemandeScreen({required this.demandeType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Traiter les demandes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gérer les demandes de ${demandeType}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Liste de demandes simulée (vous pouvez la remplacer par des données réelles)
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Par exemple 10 demandes
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('$demandeType demande ${index + 1}'),
                    subtitle: Text("Détails de la demande..."),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // Logique pour approuver la demande
                            if (demandeType == 'Réorientation') {
                              demandeReorientationController.soumettreDemandeReorientation(
                                  'Nom', 'Prénom', '12345', '01/01/2000', 'email@example.com',
                                  '0123456789', 'Informatique', '2ème année', 'Systèmes', 'Mathématiques',
                                  'Sciences', '01/09/2025', 'Motivation de l\'étudiant');
                            } else if (demandeType == 'Transfert') {
                              demandeTransfertController.soumettreDemandeTransfert(
                                  'Etudiant', 'Nom', 'Prénom', '12345', '01/01/2000', 'email@example.com',
                                  '0123456789', 'Université A', 'Sciences', 'Informatique', '2ème année',
                                  'Informatique', 'CDD', 'Université B', 'Mathématiques', '01/09/2025', 'Motivation de l\'étudiant');
                            }
                            Get.snackbar('Demande traitée', 'Demande approuvée avec succès',
                                backgroundColor: Colors.green, colorText: Colors.white);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            // Logique pour refuser la demande
                            Get.snackbar('Demande traitée', 'Demande refusée avec succès',
                                backgroundColor: Colors.red, colorText: Colors.white);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

