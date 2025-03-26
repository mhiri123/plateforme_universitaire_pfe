class ReorientationRequest {
  final String studentName; // Nom de l'étudiant
  final String currentField; // Filière actuelle
  final String desiredField; // Filière désirée
  final String status; // Statut de la traiterdemande (ex. : "Pending", "Approved", "Rejected")
  final DateTime requestDate; // Date de la traiterdemande

  // Constructeur pour initialiser les variables
  ReorientationRequest({
    required this.studentName,
    required this.currentField,
    required this.desiredField,
    required this.status,
    required this.requestDate,
  });

  // Méthode pour convertir un objet ReorientationRequest en une carte (Map) pour faciliter la gestion avec un backend
  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'currentField': currentField,
      'desiredField': desiredField,
      'status': status,
      'requestDate': requestDate.toIso8601String(),
    };
  }

  // Méthode pour créer un objet ReorientationRequest à partir d'un Map
  factory ReorientationRequest.fromMap(Map<String, dynamic> map) {
    return ReorientationRequest(
      studentName: map['studentName'],
      currentField: map['currentField'],
      desiredField: map['desiredField'],
      status: map['status'],
      requestDate: DateTime.parse(map['requestDate']),
    );
  }
}
