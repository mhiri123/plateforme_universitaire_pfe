import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/demandereo_controller.dart';

class DemandeReorientationScreen extends StatefulWidget {
  @override
  _DemandeReorientationScreenState createState() => _DemandeReorientationScreenState();
}

class _DemandeReorientationScreenState extends State<DemandeReorientationScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemandeReorientationController demandeReorientationController = Get.put(DemandeReorientationController());

  // Contrôleurs pour chaque champ
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController numeroEtudiantController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController filiereActuelleController = TextEditingController();
  final TextEditingController anneeEtudeController = TextEditingController();
  final TextEditingController departementController = TextEditingController();
  final TextEditingController nouvelleFiliereController = TextEditingController();
  final TextEditingController departementSouhaiteController = TextEditingController();
  final TextEditingController dateChangementController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demande de Réorientation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Informations Personnelles", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(nomController, "Nom"),
              buildTextField(prenomController, "Prénom"),
              buildTextField(numeroEtudiantController, "Numéro d’étudiant"),
              buildTextField(dateNaissanceController, "Date de naissance"),
              buildTextField(emailController, "Adresse e-mail"),
              buildTextField(telephoneController, "Numéro de téléphone"),

              SizedBox(height: 20),

              Text("Situation Actuelle", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(filiereActuelleController, "Filière actuelle"),
              buildTextField(anneeEtudeController, "Année d’étude"),
              buildTextField(departementController, "Département/Faculté"),

              SizedBox(height: 20),

              Text("Demande de Réorientation", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(nouvelleFiliereController, "Nouvelle filière souhaitée"),
              buildTextField(departementSouhaiteController, "Département/Faculté (si applicable)"),
              buildTextField(dateChangementController, "Date souhaitée pour le changement"),

              SizedBox(height: 20),

              Text("Motivation", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              TextFormField(
                controller: motivationController,
                decoration: InputDecoration(
                  labelText: "Raisons de la réorientation",
                  hintText: "Expliquer brièvement votre traiterdemande",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez expliquer votre motivation.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Documents à Joindre
              Text("Documents à Joindre (si requis)", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(null, "Relevé de notes"),
              buildTextField(null, "Lettre de motivation"),
              buildTextField(null, "Autres :"),

              SizedBox(height: 20),

              // Bouton de Soumission
              Obx(() {
                return demandeReorientationController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      demandeReorientationController.soumettreDemandeReorientation(
                        nomController.text,
                        prenomController.text,
                        numeroEtudiantController.text,
                        dateNaissanceController.text,
                        emailController.text,
                        telephoneController.text,
                        filiereActuelleController.text,
                        anneeEtudeController.text,
                        departementController.text,
                        nouvelleFiliereController.text,
                        departementSouhaiteController.text,
                        dateChangementController.text,
                        motivationController.text,
                      );
                    }
                  },
                  child: Text("Soumettre la traiterdemande"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController? controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ce champ est requis.";
          }
          return null;
        },
      ),
    );
  }
}
