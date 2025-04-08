import 'package:get/get.dart';
import '../../../models/faculty.dart'; // Assurez-vous que vous importez correctement vos modèles
import '../../../models/admin.dart';  // Importer le modèle Admin
import '../../../models/student.dart';  // Importer le modèle Student

class FacultyController extends GetxController {
  var isLoading = true.obs;
  var facultyList = <Faculty>[];

  @override
  void onInit() {
    super.onInit();
    fetchFaculties();
  }

  // Récupérer les facultés fictives
  Future<void> fetchFaculties() async {
    try {
      isLoading(true);
      // Simule un délai pour l'exemple
      await Future.delayed(Duration(seconds: 2));

      // Exemple de données simulées avec les paramètres requis
      facultyList = [
        Faculty(
          id: 1,
          name: "Faculté des Sciences",
          admins: [
            Admin(id: 1, name: "Dr. Dupont", email: "dr.dupont@example.com", isActive: true),
            Admin(id: 2, name: "Dr. Martin", email: "dr.martin@example.com", isActive: true),
          ],
          students: [
            Student(id: 3, name: "Alice", email: "alice@example.com", isActive: true),
            Student(id: 4, name: "Bob", email: "bob@example.com", isActive: false),
          ],
        ),
        Faculty(
          id: 2,
          name: "Faculté de Médecine",
          admins: [
            Admin(id: 3, name: "Dr. Lefevre", email: "dr.lefevre@example.com", isActive: true),
          ],
          students: [
            Student(id: 5, name: "Charlie", email: "charlie@example.com", isActive: true),
          ],
        ),
      ];
    } catch (e) {
      print("Erreur lors du chargement des facultés : $e");
    } finally {
      isLoading(false);
    }
  }

  // Méthode pour obtenir une faculté par son ID
  Faculty? getFacultyById(int id) {
    return facultyList.firstWhereOrNull((faculty) => faculty.id == id);
  }
}
