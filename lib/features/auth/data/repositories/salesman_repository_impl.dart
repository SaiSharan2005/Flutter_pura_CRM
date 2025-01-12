import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/domain/entities/salesman.dart';
import 'package:pura_crm/features/auth/domain/repositories/salesman_repository.dart';

class SalesmanRepositoryImpl implements SalesmanRepository {
  final ApiClient apiClient;

  SalesmanRepositoryImpl(this.apiClient);

  @override
  Future<Salesman> getSalesmanDetailsAboutSelf() async {
    final response = await apiClient.get('/salesman-details/');
    return Salesman.fromJson(json.decode(response.body));
  }

  // @override
  // Future<Salesman> createSalesmanDetails(Salesman salesman) async {
  //   final response = await apiClient.post(
  //     '/salesman-details/createSalesman',
  //     json.encode(Salesman.fromJson(salesman.toJson())),
  //   );
  //   if (response.statusCode == 200) {
  //     return Salesman.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to create salesman. Status code: ${response.statusCode}');
  //   }
  // }

  @override
  Future<bool> createSalesmanDetails(Salesman salesman) async {
    try {
      final response = await apiClient.post(
        '/salesman-details/createSalesman',
        // headers: {'Content-Type': 'application/json'},
         json.encode(salesman.toJson()),
      );

      // Check if the status code indicates success (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;  // Indicating success
      } else {
        // If the response is not successful, log the error and return false
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle any errors (network, parsing, etc.)
      print("Error creating salesman: $e");
      return false;
    }
  }




@override
  Future<Salesman> getSalesmanDetailsById(String id) async {
    final response = await apiClient.get('/salesman-details/$id');
    return Salesman.fromJson(json.decode(response.body));
  }

  @override
  Future<void> updateSalesmanById(String id, Salesman salesman) async {
    try {
      await apiClient.put(
        '/salesman-details/$id',
        json.encode(salesman.toJson()),
      );
    } catch (e) {
      print("Error updating salesman: $e");
      throw Exception("Failed to update salesman");
    }
  }


  @override
  Future<void> deleteSalesmanById(String id) async {
    final response = await apiClient.delete('/salesman-details/$id');
    if (response.statusCode != 200) {
      throw Exception("Failed to delete salesman. Status: ${response.statusCode}");
    }
  }


  @override
  Future<void> updateSalesmanAboutSelf(Salesman salesman) async {
    await apiClient.put(
      '/salesman-details/',
      json.encode(Salesman.fromJson(salesman.toJson())),
    );
  }

  @override
  Future<List<Salesman>> getAllSalesmanDetails() async {
    final response = await apiClient.get('/salesman-details/all');
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Salesman.fromJson(json)).toList();
  }
}
