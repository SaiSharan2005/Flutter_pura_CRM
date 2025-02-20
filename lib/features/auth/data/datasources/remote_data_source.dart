import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';

class RemoteDataSource {
  final ApiClient apiClient;

  RemoteDataSource(this.apiClient);

  Future<String> register(String username, String email, String password, List<String> roles) async {
    final response = await apiClient.post(
      '/auth/register',
      jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'roles': roles,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw ('Registration failed:\n ${jsonDecode(response.body)["message"]}');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<UserDTO> me() async {
    final response = await apiClient.get('/auth/me');

    if (response.statusCode == 200) {
      // Decode JSON and convert to UserDTO
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return UserDTO.fromJson(responseData);
    } else {
      throw Exception('Unauthenticated: ${response.body}');
    }
  }

}
