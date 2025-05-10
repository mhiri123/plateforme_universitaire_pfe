class LevelModel {
  final int id;
  final String level;
  final int filiereId;

  LevelModel({
    required this.id, 
    required this.level, 
    required this.filiereId
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] ?? 0,
      level: json['level'] ?? '',
      filiereId: json['filiereId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'filiereId': filiereId,
    };
  }
}
