class User {

  final String token;
  final String role;
  final String nomPrenom;
  final String email;
  final String? avatarUrl;
  final String? classe; // classe/groupe de l'utilisateur

  User({
    required this.token,
    required this.role,
    required this.nomPrenom,
    required this.email,
    this.avatarUrl,
    this.classe,
  });

  User copyWith({
    String? token,
    String? role,
    String? nomPrenom,
    String? email,
    String? avatarUrl,
    String? classe,
  }) {
    return User(
      token: token ?? this.token,
      role: role ?? this.role,
      nomPrenom: nomPrenom ?? this.nomPrenom,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      classe: classe ?? this.classe,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      role: json['role'],
      nomPrenom: json['nomPrenom'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      classe: json['classe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomPrenom': nomPrenom,
      'email': email,
      'role': role,
      'token': token,
      'avatarUrl': avatarUrl,
      'classe': classe,
    };
  }
}
