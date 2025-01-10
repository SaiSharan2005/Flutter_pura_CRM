import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/models/salesman_model.dart';
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

  @override
  Future<Salesman> createSalesmanDetails(Salesman salesman) async {
    final response = await apiClient.post('/salesman-details/createSalesman',
      json.encode(Salesman.fromJson(salesman.toJson())),
    );
    return Salesman.fromJson(json.decode(response.body));
  }

  @override
  Future<Salesman> getSalesmanDetailsById(String id) async {
    final response = await apiClient.get('/salesman-details/$id');
    return Salesman.fromJson(json.decode(response.body));
  }

  @override
  Future<void> updateSalesmanById(String id, Salesman salesman) async {
    await apiClient.put(
      '/salesman-details/$id',
      json.encode(Salesman.fromJson(salesman.toJson())),
    );
  }

  @override
  Future<void> deleteSalesmanById(String id) async {
    await apiClient.delete('/salesman-details/$id');
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
