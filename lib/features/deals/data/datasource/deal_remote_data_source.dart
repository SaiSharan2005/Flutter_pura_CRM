// lib/features/deals/data/datasources/deal_remote_data_source.dart

import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/deals/data/models/deal_model.dart';
import 'package:pura_crm/features/deals/data/models/deal_request.dart';

abstract class DealRemoteDataSource {
  Future<DealModel> createDeal(DealRequestDto dealModel);
  Future<List<DealModel>> getAllDeals();
  Future<List<DealModel>> getDealsOfUser(int userId);
  Future<DealModel> updateDeal(int id, DealModel dealModel);
  Future<void> deleteDeal(int id);
}

class DealRemoteDataSourceImpl implements DealRemoteDataSource {
  final ApiClient apiClient;

  DealRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DealModel> createDeal(DealRequestDto dealModel) async {
    final response = await apiClient.post(
      '/deals/create',
      jsonEncode(dealModel.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DealModel.fromJson(data);
    } else {
      throw Exception('Failed to create deal');
    }
  }

  @override
  Future<List<DealModel>> getAllDeals() async {
    final response = await apiClient.get('/deals/all');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DealModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get deals');
    }
  }

  @override
  Future<List<DealModel>> getDealsOfUser(int userId) async {
    // Adjust the URL based on your backend design.
    // For example, you might need to pass the userId as a query parameter:
    // final response = await apiClient.get('/deals?userId=$userId');
    final response = await apiClient.get('/deals/');
    if (response.statusCode == 200) {
      final List<dynamic> decoded =
          await jsonDecode(response.body); // responseBody is your JSON string
      print(decoded);
      final List<DealModel> deals = decoded.map<DealModel>((dynamic dealJson) {
        try {
          final Map<String, dynamic> dealMap = dealJson as Map<String, dynamic>;
          return DealModel.fromJson(dealMap);
        } catch (e) {
          print("Error converting deal JSON: $dealJson");
          print("Error: $e");
          rethrow;
        }
      }).toList();
      print(deals.toString());

      return deals;
    } else {
      throw Exception('Failed to get deals for user');
    }
  }

  @override
  Future<DealModel> updateDeal(int id, DealModel dealModel) async {
    final response = await apiClient.put(
      '/deals/$id',
      jsonEncode(dealModel.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DealModel.fromJson(data);
    } else {
      throw Exception('Failed to update deal');
    }
  }

  @override
  Future<void> deleteDeal(int id) async {
    final response = await apiClient.delete('/deals/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete deal');
    }
  }
}
