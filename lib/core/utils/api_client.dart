import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/secure_storage_helper.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;

  // ApiClient({required this.baseUrl, http.Client? client})
  //     : client = client ?? http.Client();

  ApiClient(this.baseUrl, this.client);

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client.get(url, headers: await _defaultHeaders());
    _handleResponse(response);
    return response;
  }

  Future<http.Response> post(String endpoint, String body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client.post(
      url,
      headers: await _defaultHeaders(),
      body: body,
    );
    _handleResponse(response);
    return response;
  }

  Future<http.Response> put(String endpoint, String body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client.put(
      url,
      headers: await _defaultHeaders(),
      body: body,
    );
    _handleResponse(response);
    return response;
  }

  Future<http.Response> delete(String endpoint, {String? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await client.delete(url, headers: await _defaultHeaders());
    _handleResponse(response);
    return response;
  }

  Future<Map<String, String>> _defaultHeaders() async {
    final token = await SecureStorageHelper.getToken();

    // Create headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add Authorization header if token exists
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to load data: ${response.statusCode}, ${response.body}',
      );
    }
  }
}

// Example function to retrieve the token
// Future<String> getToken() async {
//   // Implement your logic to retrieve the JWT token here.
//   // This could be from secure storage, a local database, or an API call.
//   return 'your_jwt_token';
// }
