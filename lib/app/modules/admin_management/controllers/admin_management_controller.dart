import 'package:get/get.dart';

class AdminController extends GetxController {
  // Liste des administrateurs (à remplacer par la logique de récupération depuis un API ou une base de données)
  var admins = <Admin>[
    Admin(id: 1, name: 'Admin 1', email: 'admin1@example.com'),
    Admin(id: 2, name: 'Admin 2', email: 'admin2@example.com'),
  ].obs;

  // Méthode pour supprimer un administrateur
  void deleteAdmin(int id) {
    admins.removeWhere((admin) => admin.id == id);
  }

// Ajouter d'autres méthodes selon les besoins, comme la mise à jour des administrateurs, etc.
}

class Admin {
  final int id;
  final String name;
  final String email;

  Admin({required this.id, required this.name, required this.email});
}
