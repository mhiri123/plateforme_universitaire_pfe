import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../faculty_details/controllers/faculty_details_controller.dart';
import '../controllers/demandetransfertenseignant_controller.dart';

class DemandeTransfertEtudiantScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController faculteActuelleController = TextEditingController();
  final TextEditingController faculteDestinationController = TextEditingController();
  final TextEditingController filiereController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  File? selectedDocument;
  final Color fieldColor = Colors.white.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    final DemandeTransfertEtudiantController controller = Get.put(DemandeTransfertEtudiantController());
    final FacultyController facultyController = Get.put(FacultyController());

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/form.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 600,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Demande de Transfert',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Section Informations Personnelles
                      _sectionTitle("Informations Personnelles", Colors.blue),
                      Divider(color: Colors.white),
                      SizedBox(height: 10),
                      _styledField(nomController, "Nom"),
                      SizedBox(height: 15),
                      _styledField(prenomController, "Prénom"),
                      SizedBox(height: 15),
                      _styledField(emailController, "Email"),
                      SizedBox(height: 30),

                      // Section Situation Actuelle
                      _sectionTitle("Situation Actuelle", Colors.yellow),
                      Divider(color: Colors.white),
                      SizedBox(height: 10),

                      // Faculté Actuelle
                      Obx(() {
                        if (facultyController.isLoading.value) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue, width: 1.5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: "Faculté actuelle",
                              border: InputBorder.none,
                            ),
                            items: facultyController.facultyList.map((faculty) {
                              return DropdownMenuItem<int>(
                                value: faculty.id,
                                child: Text(faculty.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              faculteActuelleController.text = value.toString();
                            },
                            validator: (value) => value == null ? 'Ce champ est requis' : null,
                          ),
                        );
                      }),
                      SizedBox(height: 15),
                      _styledField(filiereController, "Filière"),
                      SizedBox(height: 30),

                      // Section Transfert Souhaité
                      _sectionTitle("Transfert Souhaité", Colors.green),
                      Divider(color: Colors.white),
                      SizedBox(height: 10),

                      // Faculté Destination
                      Obx(() {
                        if (facultyController.isLoading.value) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue, width: 1.5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: "Faculté de destination",
                              border: InputBorder.none,
                            ),
                            items: facultyController.facultyList.map((faculty) {
                              return DropdownMenuItem<int>(
                                value: faculty.id,
                                child: Text(faculty.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              faculteDestinationController.text = value.toString();
                            },
                            validator: (value) => value == null ? 'Ce champ est requis' : null,
                          ),
                        );
                      }),
                      SizedBox(height: 15),
                      _styledField(motivationController, "Motivation", maxLines: 4),
                      SizedBox(height: 20),

                      // Section Pièce Jointe
                      _sectionTitle("Pièce jointe", Colors.purple),
                      Divider(color: Colors.white),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            selectedDocument = File(result.files.single.path!);
                          }
                        },
                        icon: Icon(Icons.upload_file, color: Colors.purple),
                        label: Text("Ajouter document"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Bouton de Soumission
                      Center(
                        child: Obx(() => controller.isLoading.value
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.soumettreDemandeTransfertEtudiant(
                                nom: nomController.text,
                                prenom: prenomController.text,
                                email: emailController.text,
                                faculteActuelle: faculteActuelleController.text,
                                faculteDestination: faculteDestinationController.text,
                                filiere: filiereController.text,
                                motivation: motivationController.text,
                                document: selectedDocument,
                              );
                            }
                          },
                          child: Text("Soumettre"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthodes de style existantes
  Widget _styledField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
              child: Icon(
                Icons.circle,
                size: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }
}