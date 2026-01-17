/// Modèle utilisateur
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String language;
  final String timezone;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.language,
    required this.timezone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      language: json['language'] ?? 'en',
      timezone: json['timezone'] ?? 'UTC',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'language': language,
      'timezone': timezone,
    };
  }
}

/// Modèle couple
class Couple {
  final String id;
  final User partnerA;
  final User? partnerB;
  final DateTime createdAt;
  final DateTime updatedAt;

  Couple({
    required this.id,
    required this.partnerA,
    required this.partnerB,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      id: json['id'],
      partnerA: User.fromJson(json['partner_a']),
      partnerB:
          json['partner_b'] != null ? User.fromJson(json['partner_b']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Vérifier si le couple est complet (deux partenaires)
  bool get isComplete => partnerB != null;
}

/// Modèle code d'invitation
class PairingInvite {
  final String code;
  final DateTime expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;

  PairingInvite({
    required this.code,
    required this.expiresAt,
    required this.usedAt,
    required this.createdAt,
  });

  factory PairingInvite.fromJson(Map<String, dynamic> json) {
    return PairingInvite(
      code: json['code'],
      expiresAt: DateTime.parse(json['expires_at']),
      usedAt:
          json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Vérifier si le code est encore valide
  bool get isValid {
    if (usedAt != null) return false;
    return DateTime.now().isBefore(expiresAt);
  }

  /// Obtenir le temps restant avant expiration
  Duration get timeRemaining {
    return expiresAt.difference(DateTime.now());
  }
}

/// Modèle réponse d'authentification
class AuthResponse {
  final User user;
  final String access;
  final String refresh;

  AuthResponse({
    required this.user,
    required this.access,
    required this.refresh,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}
