class User {
  final int? id;
  final String username;
  final String email;
  final String? password;

  User({
    this.id,
    required this.username,
    required this.email,
    String? password,
  }) : password = password ?? "";

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
