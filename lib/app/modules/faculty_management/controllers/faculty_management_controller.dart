// controllers/faculty_controller.dart
import 'package:get/get.dart';
import '../../../models/faculty.dart';
import '../../../models/admin.dart';
import '../../../models/student.dart';

class FacultyController extends GetxController {
  var faculties = <Faculty>[].obs; // Liste des facultés observable

  @override
  void onInit() {
    super.onInit();
    _loadFaculties();
  }

  // Charger des facultés fictives
  void _loadFaculties() {
    faculties.addAll([
      Faculty(
        id: 1,
        name: "Faculté des Sciences",
        admins: [
          Admin(id: 1, name: "Admin 1", email: "admin1@example.com", isActive: true),
          Admin(id: 2, name: "Admin 2", email: "admin2@example.com", isActive: true),
        ],
        students: [
          Student(id: 3, name: "Étudiant 1", email: "etudiant1@example.com", isActive: true),
          Student(id: 4, name: "Étudiant 2", email: "etudiant2@example.com", isActive: false),
        ],
      ),
      Faculty(
        id: 2,
        name: "Faculté de Médecine",
        admins: [
          Admin(id: 5, name: "Admin 3", email: "admin3@example.com", isActive: true),
        ],
        students: [
          Student(id: 6, name: "Étudiant 3", email: "etudiant3@example.com", isActive: true),
        ],
      ),
    ]);
  }

  // Ajouter une nouvelle faculté
  void addFaculty(Faculty faculty) {
    faculties.add(faculty);
  }

  // Supprimer une faculté
  void removeFaculty(int facultyId) {
    faculties.removeWhere((faculty) => faculty.id == facultyId);
  }

  // Modifier une faculté
  void updateFaculty(Faculty updatedFaculty) {
    int index = faculties.indexWhere((faculty) => faculty.id == updatedFaculty.id);
    if (index != -1) {
      faculties[index] = updatedFaculty;
    }
  }

  // Récupérer une faculté par son ID
  Faculty? getFacultyById(int id) {
    return faculties.firstWhereOrNull((faculty) => faculty.id == id);
  }
}
