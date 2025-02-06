import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // Make the API call
      final response = await apiClient.get('/products/all');

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);
        print(data);
        final List<ProductModel> products = data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // Print the products to verify
        for (var product in products) {
          print('Product Name: ${product.productName}');
          print('Description: ${product.description}');
          print('Price: ${product.price}');
          print('User: ${product.user?.username ?? 'No user'}');
          print('---');
        }
        print(products);

        // Map the raw JSON into a list of ProductModel
        return products;
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and throw any errors
      throw Exception('Error fetching products: $error');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await apiClient.get('/products/$id');

    // Parse the response body as JSON
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    // Convert the JSON to a ProductModel instance
    return ProductModel.fromJson(responseData);
  }

  @override
  Future<void> createProduct(Product product) async {
    final String jsonData = jsonEncode((product as ProductModel).toJson());

    await apiClient.post('/products/create', jsonData);
  }

  @override
  Future<void> updateProduct(int id, Product product) async {
    final String jsonData = jsonEncode((product as ProductModel).toJson());

    await apiClient.put('/products/$id', jsonData);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await apiClient.delete('/products/$id');
  }
}

// extension on Response {
//   Map<String, dynamic> get data => null;
// }
