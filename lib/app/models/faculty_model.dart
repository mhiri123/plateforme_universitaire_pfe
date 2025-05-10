class FacultyModel {
  final int id;
  final String facultyName;
  final String facultyCode;

  FacultyModel({
    required this.id, 
    required this.facultyName, 
    required this.facultyCode
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(
      id: json['id'] ?? 0,
      facultyName: json['facultyName'] ?? '',
      facultyCode: json['facultyCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facultyName': facultyName,
      'facultyCode': facultyCode,
    };
  }
}
