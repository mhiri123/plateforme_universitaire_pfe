// Utilitaires pour les notifications

/// Convertit le type de notification local en type compatible avec l'API
/// Les types acceptés par l'API sont : 'transfert', 'reorientation', 'system', 'autre'
String getApiNotificationType(String localType) {
  // Mapping des types locaux vers les types API
  switch (localType.toLowerCase()) {
    case 'demande_reorientation':
    case 'statut_demande':
    case 'demandereorientation':
      return 'reorientation';
    case 'message_systeme':
    case 'messagesysteme':
      return 'system';
    case 'transfert':
      return 'transfert';
    case 'email':
    case 'autre':
    case 'rappel':
    default:
      return 'autre';
  }
}
