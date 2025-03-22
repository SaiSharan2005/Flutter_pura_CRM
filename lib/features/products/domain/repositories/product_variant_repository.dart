import 'package:http/http.dart' as http;
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

abstract class ProductVariantRepository {
  Future<ProductVariant> addVariant(
      int productId, ProductVariant variant, List<http.MultipartFile> images);
  Future<ProductVariant> updateVariant(
      int variantId, ProductVariant variant, List<http.MultipartFile> images);
  Future<void> deleteVariant(int variantId);
}
