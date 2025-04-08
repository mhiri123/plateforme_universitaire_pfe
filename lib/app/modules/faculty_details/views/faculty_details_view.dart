import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../faculty_details/controllers/faculty_details_controller.dart';
import '../controllers/faculty_details_controller.dart';

class FacultyDetailsScreen extends StatelessWidget {
  final FacultyController facultyController = Get.find<FacultyController>();
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Détails de ${faculty.name}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildSection("Administrateurs", faculty.admins.map((a) => a.name).toList()),
                SizedBox(height: 16),
                _buildSection("Étudiants", faculty.students.map((s) => s.name).toList()),
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
