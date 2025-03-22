import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await apiClient.get('/products/all');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await apiClient.get('/products/$id');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ProductModel.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch product with id $id');
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final String jsonData = jsonEncode((product as ProductModel).toJson());
    await apiClient.post('/products/create', jsonData);
  }

  @override
  Future<void> updateProduct(int id, Product product) async {
    final String jsonData = jsonEncode((product as ProductModel).toJson());
    await apiClient.put('/products/$id/details', jsonData);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await apiClient.delete('/products/$id');
  }
}
