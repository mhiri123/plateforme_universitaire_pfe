import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assurez-vous que le bon contrôleur est utilisé
import '../../../models/faculty.dart';
import '../controllers/faculty_details_controller.dart'; // Importer le modèle Faculty

class FacultyDetailsScreen extends StatelessWidget {
  final FacultyController facultyController = Get.find<FacultyController>(); // Assurez-vous que le bon contrôleur est utilisé
  final int facultyId;

  FacultyDetailsScreen({Key? key, required this.facultyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails de la faculté")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (facultyController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final faculty = facultyController.getFacultyById(facultyId);

          if (faculty == null) {
            return Center(
              child: Text(
                "Aucune faculté trouvée",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            );
          }

          // Simuler des données pour les administrateurs et étudiants
          List<String> admins = ["Admin 1", "Admin 2"]; // Remplacer par les administrateurs réels si disponibles
          List<String> students = ["Alice", "Bob"]; // Remplacer par les étudiants réels si disponibles

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Détails de ${faculty.name}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildSection("Administrateurs", admins),
                SizedBox(height: 16),
                _buildSection("Étudiants", students),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        if (items.isEmpty)
          Text("Aucun $title trouvé", style: TextStyle(color: Colors.grey))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                leading: Icon(Icons.person),
              );
            },
          ),
      ],
    );
  }
}
