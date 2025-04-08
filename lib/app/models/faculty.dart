// models/faculty.dart
import 'admin.dart';  // Import des classes Admin et Student
import 'student.dart';

class Faculty {
  final int id;
  final String name;
  final List<Admin> admins;
  final List<Student> students;

  Faculty({
    required this.id,
    required this.name,
    required this.admins,
    required this.students,
  });
}
