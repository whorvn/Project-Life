class User {
  final int id;
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

  bool get isAdmin => role == 'superadmin';
  bool get isOrganizer => role == 'organizer';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      role: json['role'],
      isActive: json['is_active'],
      registrationDate: DateTime.parse(json['registration_date']),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
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

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? fullName,
    String? role,
    bool? isActive,
    DateTime? registrationDate,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      registrationDate: registrationDate ?? this.registrationDate,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
