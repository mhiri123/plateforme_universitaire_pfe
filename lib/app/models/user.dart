import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';  // Le fichier généré qui contient la logique de sérialisation

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });

  // ✅ Méthode pour créer un User à partir de JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // ✅ Méthode pour convertir un User en JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // ✅ Méthode copyWith utile pour les modifications
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}

