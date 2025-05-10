import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../faculty_details/controllers/faculty_details_controller.dart';
import '../controllers/demandetransfetenseignant_controller.dart';
import '../../../models/faculty.dart';

class DemandeTransfertEnseignantScreen extends StatefulWidget {
  @override
  _DemandeTransfertEnseignantScreenState createState() =>
      _DemandeTransfertEnseignantScreenState();
}

class _DemandeTransfertEnseignantScreenState
    extends State<DemandeTransfertEnseignantScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemandeTransfertEnseignantController demandeTransfertController =
  Get.put(DemandeTransfertEnseignantController());
  final FacultyController facultyController = Get.put(FacultyController());

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController universiteActuelleController = TextEditingController();
  final TextEditingController universiteDemandeeController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  File? selectedDocument;
  final Color fieldColor = Colors.white;
  Faculty? selectedFaculteActuelle;
  Faculty? selectedFaculteDestination;

  @override
  void initState() {
    super.initState();
    facultyController.fetchFaculties();
  }

  @override
  Widget build(BuildContext context) {
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
                width: 650,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Demande de Transfert Enseignant',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),

                      // Section: Informations Personnelles
                      _sectionTitle("Informations Personnelles", Colors.blue),
                      _styledField(nomController, "Nom"),
                      _styledField(prenomController, "Prénom"),
                      _styledField(emailController, "Adresse e-mail", emailValidator),

                      Divider(color: Colors.white, height: 30, thickness: 1),

                      // Section: Situation Actuelle
                      _sectionTitle("Situation Actuelle", Colors.yellow),


                      // Liste déroulante Faculté Actuelle
                      Obx(() {
                        if (facultyController.isLoading.value) {
                          return CircularProgressIndicator();
                        }
                        return _buildFacultyDropdown(
                            "Faculté Actuelle",
                            facultyController.facultyList,
                            selectedFaculteActuelle,
                                (Faculty? faculty) {
                              setState(() {
                                selectedFaculteActuelle = faculty;
                              });
                            }
                        );
                      }),

                      Divider(color: Colors.white, height: 30, thickness: 1),

                      // Section: Transfert Souhaité
                      _sectionTitle("Transfert Souhaité", Colors.green),


                      // Liste déroulante Faculté Destination
                      Obx(() {
                        if (facultyController.isLoading.value) {
                          return CircularProgressIndicator();
                        }
                        return _buildFacultyDropdown(
                            "Faculté Destination",
                            facultyController.facultyList,
                            selectedFaculteDestination,
                                (Faculty? faculty) {
                              setState(() {
                                selectedFaculteDestination = faculty;
                              });
                            }
                        );
                      }),

                      Divider(color: Colors.white, height: 30, thickness: 1),

                      // Section: Motivation
                      _sectionTitle("Motivation", Colors.orange),
                      _styledTextArea(motivationController, "Raisons du transfert"),
                      SizedBox(height: 20),

                      // Section: Ajouter Document
                      _sectionTitle("Ajouter un Document", Colors.purple),
                      ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setState(() {
                              selectedDocument = File(result.files.single.path!);
                            });
                          }
                        },
                        icon: Icon(Icons.upload_file),
                        label: Text("Ajouter documents"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Section: Confirmation avant soumission
                      _sectionTitle("Vérification et Soumission", Colors.red),
                      _confirmationSection(),
                      SizedBox(height: 30),

                      Obx(() {
                        return demandeTransfertController.isLoading.value
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text("Soumettre la demande"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      }),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Vérifier que tous les champs obligatoires sont remplis
      if (selectedDocument == null) {
        Get.snackbar(
          'Erreur',
          'Veuillez ajouter un document',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validation des facultés
      if (selectedFaculteActuelle == null || selectedFaculteDestination == null) {
        Get.snackbar(
          'Erreur',
          'Veuillez sélectionner les facultés',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      demandeTransfertController.soumettreDemandeTransfertEnseignant(
        nom: nomController.text,
        prenom: prenomController.text,
        email: emailController.text,

        faculteActuelle: selectedFaculteActuelle!.name,

        faculteDestination: selectedFaculteDestination!.name,
        motivation: motivationController.text,
        document: selectedDocument,
      );
    }
  }

  Widget _buildFacultyDropdown(
      String hintText,
      List<Faculty> faculties,
      Faculty? currentValue,
      Function(Faculty?) onChanged
      ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: DropdownButtonFormField<Faculty>(
        value: currentValue,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        items: faculties.map((faculty) {
          return DropdownMenuItem<Faculty>(
            value: faculty,
            child: Text(faculty.name),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 8),
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
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    final emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    final regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Entrez une adresse e-mail valide';
    }
    return null;
  }

  Widget _styledField(
      TextEditingController controller,
      String label,
      [FormFieldValidator<String>? validator]
      ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        validator: validator ?? (value) =>
        value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _styledTextArea(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        validator: (value) =>
        value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _confirmationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Veuillez vérifier vos informations avant de soumettre.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: 10),
        selectedDocument != null
            ? Text(
          'Document téléchargé: ${selectedDocument!.path.split('/').last}',
          style: TextStyle(color: Colors.white),
        )
            : SizedBox.shrink(),
      ],
    );
  }
}