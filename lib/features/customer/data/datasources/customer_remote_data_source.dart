// lib/features/customer/data/datasources/customer_remote_data_source.dart

import 'dart:convert';
import 'package:pura_crm/core/utils/api_client.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerModel> createCustomer(CustomerModel customerModel);
  Future<List<CustomerModel>> getAllCustomers();
  Future<CustomerModel> getCustomerById(int id);
  Future<CustomerModel> updateCustomerById(int id, CustomerModel customerModel);
  Future<void> deleteCustomerById(int id);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final ApiClient apiClient;

  CustomerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CustomerModel> createCustomer(CustomerModel customerModel) async {
    final response = await apiClient.post(
      '/customers/create',
      jsonEncode(customerModel.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CustomerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create customer');
    }
  }

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    final response = await apiClient.get('/customers/all');
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((json) => CustomerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get customers');
    }
  }

  @override
  Future<CustomerModel> getCustomerById(int id) async {
    final response = await apiClient.get('/customers/$id');
    if (response.statusCode == 200) {
      return CustomerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get customer');
    }
  }

  @override
  Future<CustomerModel> updateCustomerById(
      int id, CustomerModel customerModel) async {
    final response = await apiClient.put(
      '/customers/$id',
      jsonEncode(customerModel.toJson()),
    );
    if (response.statusCode == 200) {
      return CustomerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update customer');
    }
  }

  @override
  Future<void> deleteCustomerById(int id) async {
    final response = await apiClient.delete('/customers/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer');
    }
  }
}
