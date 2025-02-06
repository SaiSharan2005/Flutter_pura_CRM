class User {
  final int? id;
  final String username;
  final String email;
  final String? password;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
  });

  // Factory method to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?, // Allow null values
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'username': username,
      'email': email,
      'password': password, // No change needed for null safety
    };
  }
}
