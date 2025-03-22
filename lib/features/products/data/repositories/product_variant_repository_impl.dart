import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/products/data/models/product_variant_model.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';
import 'package:pura_crm/features/products/domain/repositories/product_variant_repository.dart';

class ProductVariantRepositoryImpl implements ProductVariantRepository {
  final ApiClient apiClient;

  ProductVariantRepositoryImpl(this.apiClient);

  @override
  Future<ProductVariant> addVariant(int productId, ProductVariant variant,
      List<http.MultipartFile> images) async {
    final variantJson = jsonEncode((variant as ProductVariantModel).toJson());
    final response = await apiClient.postMultipart(
      '/products/$productId/variants',
      variantJson,
      images,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return ProductVariantModel.fromJson(responseData);
    } else {
      throw Exception('Failed to add variant: ${response.statusCode}');
    }
  }

  @override
  Future<ProductVariant> updateVariant(int variantId, ProductVariant variant,
      List<http.MultipartFile> images) async {
    final variantJson = jsonEncode((variant as ProductVariantModel).toJson());
    final response = await apiClient.putMultipart(
      '/products/variants/$variantId',
      variantJson,
      images,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return ProductVariantModel.fromJson(responseData);
    } else {
      throw Exception('Failed to update variant: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteVariant(int variantId) async {
    final response = await apiClient.delete('/products/$variantId/variants');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete variant: ${response.statusCode}');
    }
  }
}
