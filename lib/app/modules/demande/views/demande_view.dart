import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/demande_controller.dart';

class DemandeScreen extends StatelessWidget {
  final DemandeController demandeController = Get.put(DemandeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes demandes")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(F
              itemCount: demandeController.demandes.length,
              itemBuilder: (context, index) {
                var demande = demandeController.demandes[index];
                return ListTile(
                  title: Text(demande["type"]),
                  subtitle: Text(demande["description"]),
                  trailing: Text(demande["statut"],
                      style: TextStyle(color: Colors.blue)),
                );
              },
            )),
          ),
          ElevatedButton(
            onPressed: () => afficherDialog(context),
            child: Text("Faire une demande"),
          ),
        ],
      ),
    );
  }

  void afficherDialog(BuildContext context) {
    String type = "Réorientation";
    String description = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nouvelle demande"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: type,
              items: ["Réorientation", "Transfert"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                type = val!;
              },
            ),
            TextField(
              onChanged: (val) => description = val,
              decoration: InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              demandeController.ajouterDemande(type, description);
              Navigator.pop(context);
            },
            child: Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
