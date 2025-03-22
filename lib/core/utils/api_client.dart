import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/secure_storage_helper.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;

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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
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

  // Multipart POST method
  Future<http.Response> postMultipart(
      String endpoint, String jsonData, List<http.MultipartFile> files) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest("POST", url);
    request.fields['data'] = jsonData;
    request.files.addAll(files);
    request.headers.addAll(await _defaultHeaders());
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _handleResponse(response);
    return response;
  }

  // Multipart PUT method
  Future<http.Response> putMultipart(
      String endpoint, String jsonData, List<http.MultipartFile> files) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest("PUT", url);
    request.fields['data'] = jsonData;
    request.files.addAll(files);
    request.headers.addAll(await _defaultHeaders());
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _handleResponse(response);
    return response;
  }
}
