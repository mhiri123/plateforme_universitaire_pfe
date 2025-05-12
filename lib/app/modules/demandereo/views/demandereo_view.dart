import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../faculty_details/controllers/faculty_details_controller.dart';
import '../../home/controllers/user_controller.dart';
import '../controllers/demande_reorientation_controller.dart';

class DemandeReorientationScreen extends StatelessWidget {
  DemandeReorientationScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final RxString selectedDocumentPath = ''.obs;
  final RxString selectedDocumentName = ''.obs;

  final FacultyController facultyController = Get.put(FacultyController());
  final UserController userController = Get.find<UserController>();
  final DemandeReorientationController demandeController = Get.put(DemandeReorientationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildBlurOverlay(),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() => Image.asset(
    'assets/images/form.jpg',
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );

  Widget _buildBlurOverlay() => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
    child: Container(color: Colors.black.withOpacity(0.3)),
  );

  Widget _buildForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Demande de Réorientation',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Divider(color: Colors.white),
                _section("Informations Personnelles", Icons.person),
                _styledField(demandeController.nomController, "Nom", enabled: false),
                _styledField(demandeController.prenomController, "Prénom", enabled: false),
                _styledField(demandeController.filiereActuelleController, "Filière actuelle", enabled: false),
                _styledField(demandeController.niveauController, "Niveau", enabled: false),
                _styledField(demandeController.faculteController, "Faculté actuelle", enabled: false),
                const Divider(color: Colors.white),
                _section("Réorientation Souhaitée", Icons.school),
                _styledField(demandeController.nouvelleFiliereController, "Nouvelle filière souhaitée"),
                _styledField(demandeController.motivationController, "Motivation", maxLines: 3),
                const Divider(color: Colors.white),
                _section("Pièce jointe", Icons.attach_file),
                _buildDocumentPickerButton(context),
                const SizedBox(height: 20),
                Obx(() => demandeController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : _buildSubmitButton()),
                if (demandeController.errorMessage.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      demandeController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _styledField(TextEditingController controller, String label, {int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? Colors.black : Colors.grey[600],
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: enabled ? Colors.black : Colors.grey[600]),
          filled: true,
          fillColor: enabled ? Colors.white.withOpacity(0.85) : Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _buildDocumentPickerButton(BuildContext context) {
    return Obx(() => ElevatedButton.icon(
      onPressed: () => _pickDocument(),
      icon: const Icon(Icons.upload_file),
      label: Text(
        selectedDocumentName.value.isNotEmpty
            ? selectedDocumentName.value
            : "Ajouter un document justificatif (optionnel)",
        overflow: TextOverflow.ellipsis,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDocumentPath.value.isEmpty
            ? Colors.white
            : Colors.green,
        foregroundColor: selectedDocumentPath.value.isEmpty
            ? Colors.black
            : Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ));
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      selectedDocumentPath.value = result.files.single.path!;
      selectedDocumentName.value = result.files.single.name;
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          File? file;
          if (selectedDocumentPath.value.isNotEmpty) {
            file = File(selectedDocumentPath.value);
          }

          await demandeController.soumettreDemandeReorientation(
            nouvelleFiliere: demandeController.nouvelleFiliereController.text,
            motivation: demandeController.motivationController.text,
            pieceJustificative: file,
          );

          selectedDocumentPath.value = '';
          selectedDocumentName.value = '';
        }
      },
      icon: const Icon(Icons.send),
      label: const Text("Soumettre"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }

  Widget _section(String title, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
