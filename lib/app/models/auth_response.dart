import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

// Fonctions utilitaires pour la conversion de niveau
int _parseNiveau(dynamic niveau) {
  if (niveau == null) return 1;

  if (niveau is int) return niveau;

  if (niveau is String) {
    switch (niveau.toUpperCase()) {
      case 'L1': return 1;
      case 'L2': return 2;
      default:
        return int.tryParse(niveau) ?? 1;
    }
  }

  return 1;
}

String _getNiveauLibelle(int niveau) {
  switch (niveau) {
    case 1: return 'Première année Licence';
    case 2: return 'Deuxième année Licence';
    default: return 'Non défini';
  }
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  createToJson: true,
)
class User {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'nom')
  final String nom;

  @JsonKey(name: 'prenom')
  final String prenom;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'role')
  final String role;

  @JsonKey(name: 'faculty', includeIfNull: true)
  final String? faculty;

  @JsonKey(name: 'filiere', includeIfNull: true)
  final String? filiere;

  @JsonKey(
      name: 'niveau',
      fromJson: _parseNiveau,
      defaultValue: 1
  )
  final int niveau;

  @JsonKey(name: 'niveau_libelle', includeIfNull: true)
  final String? niveauLibelle;

  @JsonKey(name: 'is_active', defaultValue: false)
  final bool isActive;

  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool isVerified;

  @JsonKey(includeIfNull: true)
  final String? token;

  const User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.faculty,
    this.filiere,
    this.niveau = 1,
    this.niveauLibelle,
    this.isActive = false,
    this.isVerified = false,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$prenom $nom';

  String get displayNiveauLibelle {
    return niveauLibelle ?? _getNiveauLibelle(niveau);
  }

  bool get isValidUser {
    return id > 0 &&
        nom.isNotEmpty &&
        prenom.isNotEmpty &&
        email.isNotEmpty &&
        role.isNotEmpty;
  }

  User copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? email,
    String? role,
    String? faculty,
    String? filiere,
    int? niveau,
    String? niveauLibelle,
    bool? isActive,
    bool? isVerified,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      role: role ?? this.role,
      faculty: faculty ?? this.faculty,
      filiere: filiere ?? this.filiere,
      niveau: niveau ?? this.niveau,
      niveauLibelle: niveauLibelle ?? this.niveauLibelle,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is User &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nom == other.nom &&
              prenom == other.prenom &&
              email == other.email &&
              role == other.role &&
              faculty == other.faculty &&
              filiere == other.filiere &&
              niveau == other.niveau &&
              isActive == other.isActive &&
              isVerified == other.isVerified &&
              token == other.token);

  @override
  int get hashCode => Object.hash(
    id,
    nom,
    prenom,
    email,
    role,
    faculty,
    filiere,
    niveau,
    isActive,
    isVerified,
    token,
  );

  @override
  String toString() {
    return '''
User {
  id: $id,
  nom: $nom,
  prenom: $prenom,
  email: $email,
  role: $role,
  faculty: $faculty,
  filiere: $filiere,
  niveau: $niveau (${displayNiveauLibelle}),
  isActive: $isActive,
  isVerified: $isVerified,
  token: $token
}''';
  }
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class AuthResponse {
  @JsonKey(name: 'message', defaultValue: '')
  final String message;

  @JsonKey(name: 'user')
  final User user;

  @JsonKey(name: 'token')
  final String token;

  AuthResponse({
    this.message = '',
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  // Méthode de validation complète
  bool get isValid {
    return user.isValidUser &&
        token.isNotEmpty &&
        token.length > 10;  // Exemple de validation de token
  }

  // Méthode pour obtenir un message d'erreur si l'authentification échoue
  String? get validationError {
    if (!user.isValidUser) return 'Informations utilisateur invalides';
    if (token.isEmpty || token.length <= 10) return 'Token d\'authentification invalide';
    return null;
  }

  @override
  String toString() {
    return '''
AuthResponse {
  message: $message,
  user: $user,
  token: ${token.isNotEmpty ? '[MASKED]' : 'N/A'}
}''';
  }
}