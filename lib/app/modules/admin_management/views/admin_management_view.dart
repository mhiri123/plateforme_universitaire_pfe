import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_management_controller.dart';

class AdminManagementScreen extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Administrateurs")),
      body: Obx(() {
        return ListView.builder(
          itemCount: adminController.admins.length,
          itemBuilder: (context, index) {
            final admin = adminController.admins[index];
            return ListTile(
              title: Text(admin.name),
              subtitle: Text(admin.email),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  adminController.deleteAdmin(admin.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
