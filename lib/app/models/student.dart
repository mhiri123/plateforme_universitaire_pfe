class Student {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
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
