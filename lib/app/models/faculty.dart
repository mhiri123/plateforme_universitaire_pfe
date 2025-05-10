import 'admin.dart';
import 'student.dart';

class Faculty {
  final int id;
  final String name;
  final String code;
  final String address;
  final String description;
  final List<Admin> admins;
  final List<Student> students;

  Faculty({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.description,
    this.admins = const [],
    this.students = const [],
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'],
      name: json['name'],
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      admins: (json['admins'] as List?)?.map((a) => Admin.fromJson(a)).toList() ?? [],
      students: (json['students'] as List?)?.map((s) => Student.fromJson(s)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'description': description,
      'admins': admins.map((a) => a.toJson()).toList(),
      'students': students.map((s) => s.toJson()).toList(),
    };
  }
}
