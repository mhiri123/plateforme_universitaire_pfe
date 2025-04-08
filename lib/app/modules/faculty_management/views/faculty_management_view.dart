import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../faculty_management/controllers/faculty_management_controller.dart';
import '../../../models/faculty.dart';

class FacultyManagementScreen extends StatelessWidget {
  final FacultyController facultyController = Get.put(FacultyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Facultés")),
      body: Obx(() {
        return ListView.builder(
          itemCount: facultyController.faculties.length,
          itemBuilder: (context, index) {
            final faculty = facultyController.faculties[index];
            return ListTile(
              title: Text(faculty.name),
              subtitle: Text("Admins: ${faculty.admins.length} | Étudiants: ${faculty.students.length}"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Get.toNamed("/edit_faculty", arguments: faculty);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
