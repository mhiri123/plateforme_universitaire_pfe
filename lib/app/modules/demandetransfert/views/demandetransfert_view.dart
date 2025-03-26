import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/demandetransfert_controller.dart';

class DemandeTransfertScreen extends StatefulWidget {
  @override
  _DemandeTransfertScreenState createState() => _DemandeTransfertScreenState();
}

class _DemandeTransfertScreenState extends State<DemandeTransfertScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemandeTransfertController demandeTransfertController = Get.put(DemandeTransfertController());

  // Contrôleurs pour chaque champ
  final TextEditingController statutController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController numeroIdentificationController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController institutActuelController = TextEditingController();
  final TextEditingController departementController = TextEditingController();
  final TextEditingController filiereController = TextEditingController();
  final TextEditingController anneeEtudeController = TextEditingController();
  final TextEditingController disciplineController = TextEditingController();
  final TextEditingController typeContratController = TextEditingController();
  final TextEditingController institutDemandeController = TextEditingController();
  final TextEditingController departementDemandeController = TextEditingController();
  final TextEditingController dateTransfertController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demande de Transfert")),
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
              buildTextField(numeroIdentificationController, "Numéro d’identification"),
              buildTextField(dateNaissanceController, "Date de naissance"),
              buildTextField(emailController, "Adresse e-mail"),
              buildTextField(telephoneController, "Numéro de téléphone"),

              SizedBox(height: 20),

              Text("Situation Actuelle", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(institutActuelController, "Institut actuel"),
              buildTextField(departementController, "Département/Faculté"),

              // Étudiant ou Enseignant
              Obx(() {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text("Étudiant"),
                            value: "Étudiant",
                            groupValue: statutController.text.isEmpty ? null : statutController.text,
                            onChanged: (value) {
                              setState(() {
                                statutController.text = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("Enseignant"),
                            value: "Enseignant",
                            groupValue: statutController.text.isEmpty ? null : statutController.text,
                            onChanged: (value) {
                              setState(() {
                                statutController.text = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (statutController.text == "Étudiant") ...[
                      buildTextField(filiereController, "Filière"),
                      buildTextField(anneeEtudeController, "Année d’étude"),
                    ] else if (statutController.text == "Enseignant") ...[
                      buildTextField(disciplineController, "Discipline enseignée"),
                      buildTextField(typeContratController, "Type de contrat"),
                    ],
                  ],
                );
              }),

              SizedBox(height: 20),

              Text("Demande de Transfert", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(institutDemandeController, "Institut demandé"),
              buildTextField(departementDemandeController, "Département/Faculté cible"),
              buildTextField(dateTransfertController, "Date souhaitée pour le transfert"),

              SizedBox(height: 20),

              Text("Motivation", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              TextFormField(
                controller: motivationController,
                decoration: InputDecoration(
                  labelText: "Raisons du transfert",
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
              Text("Documents à Joindre", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              buildTextField(null, "Relevé de notes (si étudiant)"),
              buildTextField(null, "CV (si enseignant)"),
              buildTextField(null, "Lettre de motivation"),
              buildTextField(null, "Attestation de l’institut actuel"),
              buildTextField(null, "Autres :"),

              SizedBox(height: 20),

              // Bouton de Soumission
              Obx(() {
                return demandeTransfertController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      demandeTransfertController.soumettreDemandeTransfert(
                        statutController.text,
                        nomController.text,
                        prenomController.text,
                        numeroIdentificationController.text,
                        dateNaissanceController.text,
                        emailController.text,
                        telephoneController.text,
                        institutActuelController.text,
                        departementController.text,
                        filiereController.text,
                        anneeEtudeController.text,
                        disciplineController.text,
                        typeContratController.text,
                        institutDemandeController.text,
                        departementDemandeController.text,
                        dateTransfertController.text,
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
