import 'dart:convert';

class UserDTO {
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  UserDTO({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  // Factory constructor to parse JSON into UserDTO
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
    );
  }

  // Method to convert UserDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
