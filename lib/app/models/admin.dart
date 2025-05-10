class Admin {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'is_active': isActive,
    };
  }
}
