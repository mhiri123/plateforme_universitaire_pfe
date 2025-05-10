class FiliereModel {
  final int id;
  final String filiereName;
  final int facultyId;

  FiliereModel({
    required this.id, 
    required this.filiereName, 
    required this.facultyId
  });

  factory FiliereModel.fromJson(Map<String, dynamic> json) {
    return FiliereModel(
      id: json['id'] ?? 0,
      filiereName: json['filiereName'] ?? '',
      facultyId: json['facultyId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filiereName': filiereName,
      'facultyId': facultyId,
    };
  }
}
