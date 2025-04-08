class NotificationModel {
  final String titre;
  final String message;
  final String recipient; // Destinataire
  final DateTime timestamp; // Horodatage
  final int id; // Identifiant unique

  NotificationModel({
    required this.titre,
    required this.message,
    required this.recipient,
    required this.id,
  }) : timestamp = DateTime.now(); // Enregistre le moment de la création
}
