import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';

class UserManagementScreen extends StatelessWidget {
  final UserManagementController userController = Get.put(UserManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Utilisateurs")),
      body: Obx(() {
        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed("/edit_user", arguments: user);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(context, user.id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/add_user"); // Navigue vers un écran d'ajout
        },
        child: Icon(Icons.add),
        tooltip: "Ajouter un utilisateur",
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirmer la suppression"),
        content: Text("Voulez-vous vraiment supprimer cet utilisateur ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              userController.deleteUser(userId);
              Navigator.of(context).pop();
            },
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }
}
