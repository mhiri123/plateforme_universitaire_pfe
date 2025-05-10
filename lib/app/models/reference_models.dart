class RoleModel {
  final int id;
  final String name;

  RoleModel({required this.id, required this.name}) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Le nom du rôle ne peut pas être vide');
    }
  }

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final name = json['name'] as String?;
    if (id == null || name == null || name.trim().isEmpty) {
      throw ArgumentError('L\'id et le nom du rôle sont requis');
    }
    return RoleModel(id: id, name: name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RoleModel && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);

  static List<RoleModel> get predefinedRoles => [
    RoleModel(id: 1, name: 'super_admin'),
    RoleModel(id: 2, name: 'admin'),
    RoleModel(id: 3, name: 'enseignant'),
    RoleModel(id: 4, name: 'etudiant'),
  ];
}

class FacultyModel {
  final int id;
  final String facultyName;
  final String? gouvernorat; // <-- nom exact du champ

  FacultyModel({
    required this.id,
    required this.facultyName,
    this.gouvernorat,
  }) {
    if (facultyName.trim().isEmpty) {
      throw ArgumentError('Le nom de la faculté ne peut pas être vide');
    }
  }

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final facultyName = json['faculty_name'] as String?;
    final gouvernorat = json['gouvernorat'] as String?; // <-- correspondance exacte

    if (id == null || facultyName == null || facultyName.trim().isEmpty) {
      throw ArgumentError('L\'id et le nom de la faculté sont requis');
    }

    return FacultyModel(
      id: id,
      facultyName: facultyName,
      gouvernorat: gouvernorat,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'faculty_name': facultyName,
    'gouvernorat': gouvernorat,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FacultyModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              facultyName == other.facultyName;

  @override
  int get hashCode => Object.hash(id, facultyName);
}


class FiliereModel {
  final int id;
  final String filiereName;
  final String facultyName;

  FiliereModel({required this.id, required this.filiereName, required this.facultyName}) {
    if (filiereName.trim().isEmpty) {
      throw ArgumentError('Le nom de la filière ne peut pas être vide');
    }
    if (facultyName.trim().isEmpty) {
      throw ArgumentError('Le nom de la faculté ne peut pas être vide');
    }
  }

  factory FiliereModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final filiereName = json['filiere_name'] as String?;
    final facultyName = json['faculty_name'] as String?;
    if (id == null || filiereName == null || facultyName == null || filiereName.trim().isEmpty || facultyName.trim().isEmpty) {
      throw ArgumentError('L\'id, le nom de la filière et le nom de la faculté sont requis');
    }
    return FiliereModel(id: id, filiereName: filiereName, facultyName: facultyName);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'filiere_name': filiereName,
    'faculty_name': facultyName,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FiliereModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              filiereName == other.filiereName &&
              facultyName == other.facultyName;

  @override
  int get hashCode => Object.hash(id, filiereName, facultyName);
}

class LevelModel {
  final int id;
  final String level;

  LevelModel({required this.id, required this.level}) {
    if (level.trim().isEmpty) {
      throw ArgumentError('Le niveau ne peut pas être vide');
    }
    if (!RegExp(r'^[1-6]$').hasMatch(level)) {
      throw ArgumentError('Le niveau doit être un chiffre entre 1 et 6');
    }
  }

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final level = json['level'] as String?;
    if (id == null || level == null || level.trim().isEmpty || !RegExp(r'^[1-6]$').hasMatch(level)) {
      throw ArgumentError('L\'id et le niveau sont requis et doivent être valides');
    }
    return LevelModel(id: id, level: level);
  }

  Map<String, dynamic> toJson() => {'id': id, 'level': level};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LevelModel && runtimeType == other.runtimeType && id == other.id && level == other.level;

  @override
  int get hashCode => Object.hash(id, level);
}
