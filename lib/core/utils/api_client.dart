import 'package:http/http.dart' as http;
class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient(this.baseUrl, this.client);

  Future<http.Response> post(String path, String body) {
    final url = Uri.parse('$baseUrl$path');
    return client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
