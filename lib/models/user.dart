class User {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime registrationDate;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.registrationDate,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? 'organizer',
      isActive: json['is_active'] ?? true,
      registrationDate: DateTime.parse(json['registration_date']),
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'role': role,
      'is_active': isActive,
      'registration_date': registrationDate.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  bool get isSuperAdmin => role == 'superadmin';
  bool get isOrganizer => role == 'organizer';
}

class AuthToken {
  final String accessToken;
  final String tokenType;
  final User user;
  final int expiresIn;

  AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.expiresIn,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      user: User.fromJson(json['user']),
      expiresIn: json['expires_in'] ?? 1800,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'user': user.toJson(),
      'expires_in': expiresIn,
    };
  }
}
