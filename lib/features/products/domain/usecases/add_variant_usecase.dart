import 'package:http/http.dart' as http;

import '../entities/product_variant.dart';
import '../repositories/product_variant_repository.dart';

class AddVariantUseCase {
  final ProductVariantRepository repository;

  AddVariantUseCase(this.repository);

  Future<ProductVariant> call(int productId, ProductVariant variant,
      List<http.MultipartFile> images) async {
    return await repository.addVariant(productId, variant, images);
  }
}
