import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user.dart';
import '../controllers/user_activation_controller.dart';

class UserActivationScreen extends StatelessWidget {
  final UserActivationController userController = Get.put(UserActivationController());

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activation des Utilisateurs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showAddUserDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => userController.filterUsers(value),
              decoration: const InputDecoration(
                hintText: "Rechercher un utilisateur...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (userController.filteredUsers.isEmpty) {
                return const Center(child: Text("Aucun utilisateur trouvé."));
              }
              return ListView.builder(
                itemCount: userController.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = userController.filteredUsers[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: user.isActive,
                          onChanged: (value) {
                            userController.toggleUserStatus(user.id, value);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, user.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              userController.deleteUser(userId);
              Navigator.of(ctx).pop();
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = "student";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ajouter un utilisateur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            DropdownButton<String>(
              value: selectedRole,
              items: ["student", "teacher", "admin"]
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedRole = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              final newUser = User(
                id: 0,
                name: nameController.text,
                email: emailController.text,
                role: selectedRole,
                isActive: true,
              );
              userController.addUser(newUser);
              Navigator.of(ctx).pop();
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
