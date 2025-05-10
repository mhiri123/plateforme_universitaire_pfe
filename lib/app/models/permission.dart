import 'package:get/get.dart';

class Permission {
  final int id;
  final String role;
  final String access;
  RxBool isActive;

  Permission({
    required this.id,
    required this.role,
    required this.access,
    required bool isActive,
  }) : isActive = isActive.obs;

  // Utilisé pour comparer avec hasPermission(...)
  String get name => access;

  // Factory pour créer une instance depuis un JSON
  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] ?? 0,
      role: json['role'] ?? '',
      access: json['access'] ?? json['name'] ?? '', // Support des 2 cas
      isActive: json['is_active'] ?? true,
    );
  }
}
