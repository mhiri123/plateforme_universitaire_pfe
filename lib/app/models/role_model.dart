class RoleModel {
  final String name;
  final int id;

  RoleModel({required this.name, required this.id});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
