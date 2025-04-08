import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/permission_management_controller.dart';  // Assure-toi du bon chemin

class PermissionManagementScreen extends StatelessWidget {
  final PermissionController permissionController = Get.put(PermissionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Permissions")),
      body: Obx(() {
        return ListView.builder(
          itemCount: permissionController.permissions.length,
          itemBuilder: (context, index) {
            final permission = permissionController.permissions[index];
            return ListTile(
              title: Text(permission.role),
              subtitle: Text("Accès: ${permission.access}"),
              trailing: Switch(
                value: permission.isActive.value, // Utilisation de .value pour accéder à la valeur de RxBool
                onChanged: (value) {
                  permissionController.togglePermission(permission.id, value);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
