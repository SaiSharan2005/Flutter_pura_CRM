import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  static Future<void> saveUserData(UserDTO user) async {
    final userJson = jsonEncode(user.toJson()); // Convert UserDTO to JSON string
    await _storage.write(key: 'user_data', value: userJson);
  }

  static Future<UserDTO?> getUserData() async {
    final userJson = await _storage.read(key: 'user_data');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserDTO.fromJson(userMap); // Convert JSON string back to UserDTO
    }
    return null;
  }

  // Delete user data
  static Future<void> deleteUserData() async {
    await _storage.delete(key: 'user_data');
  }
}
