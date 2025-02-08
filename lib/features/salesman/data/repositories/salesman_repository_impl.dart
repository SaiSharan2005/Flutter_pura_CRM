import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';

class SalesmanRepositoryImpl implements SalesmanRepository {
  final ApiClient apiClient;

  SalesmanRepositoryImpl(this.apiClient);

  @override
  Future<Salesman> getSalesmanDetailsAboutSelf() async {
    try {
      final response = await apiClient.get('/salesman-details/');
      if (response.statusCode == 200) {
        return Salesman.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            "Failed to fetch salesman details. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching salesman details: $e");
    }
  }

  @override
  Future<bool> createSalesmanDetails(Salesman salesman) async {
    try {
      final response = await apiClient.post(
        '/salesman-details/createSalesman',
        json.encode(salesman.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error creating salesman: $e");
      return false;
    }
  }

  @override
  Future<Salesman> getSalesmanDetailsById(String id) async {
    try {
      final response = await apiClient.get('/salesman-details/$id');
      if (response.statusCode == 200) {
        return Salesman.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            "Failed to fetch salesman by ID. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching salesman by ID: $e");
    }
  }

  @override
  Future<bool> updateSalesmanById(String id, Salesman salesman) async {
    try {
      final response = await apiClient.put(
        '/salesman-details/$id',
        json.encode(salesman.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating salesman: $e");
      return false;
    }
  }

  @override
  Future<void> deleteSalesmanById(String id) async {
    try {
      final response = await apiClient.delete('/salesman-details/$id');
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to delete salesman. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting salesman: $e");
    }
  }

  @override
  Future<void> updateSalesmanAboutSelf(Salesman salesman) async {
    try {
      await apiClient.put(
        '/salesman-details/',
        json.encode(salesman.toJson()),
      );
    } catch (e) {
      throw Exception("Error updating self details: $e");
    }
  }

  @override
  Future<List<Salesman>> getAllSalesmanDetails() async {
    try {
      final response = await apiClient.get('/salesman-details/all');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Salesman.fromJson(json)).toList();
      } else {
        throw Exception(
            "Failed to fetch all salesmen. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching all salesmen: $e");
    }
  }
}
