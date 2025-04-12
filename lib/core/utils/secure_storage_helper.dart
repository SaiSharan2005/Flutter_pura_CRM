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

  // Save user data
  static Future<void> saveUserData(UserDTO user) async {
    final userJson = jsonEncode(user.toJson()); // Convert UserDTO to JSON string
    await _storage.write(key: 'user_data', value: userJson);
  }

  // Get user data
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

  // Save selected customer (assumed to be representable as JSON)
  static Future<void> saveSelectedCustomer(Map<String, dynamic> customer) async {
    final customerJson = jsonEncode(customer);
    await _storage.write(key: 'selected_customer', value: customerJson);
  }

  // Get selected customer
  static Future<Map<String, dynamic>?> getSelectedCustomer() async {
    final customerJson = await _storage.read(key: 'selected_customer');
    if (customerJson != null) {
      return jsonDecode(customerJson);
    }
    return null;
  }

  // Delete selected customer
  static Future<void> deleteSelectedCustomer() async {
    await _storage.delete(key: 'selected_customer');
  }

  // Save selected cart (assumed to be representable as JSON)
  static Future<void> saveSelectedCart(Map<String, dynamic> cart) async {
    final cartJson = jsonEncode(cart);
    await _storage.write(key: 'selected_cart', value: cartJson);
  }

  // Get selected cart
  static Future<Map<String, dynamic>?> getSelectedCart() async {
    final cartJson = await _storage.read(key: 'selected_cart');
    if (cartJson != null) {
      return jsonDecode(cartJson);
    }
    return null;
  }

  // Delete selected cart
  static Future<void> deleteSelectedCart() async {
    await _storage.delete(key: 'selected_cart');
  }
}
