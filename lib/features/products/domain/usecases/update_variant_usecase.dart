import 'package:http/http.dart' as http;

import '../entities/product_variant.dart';
import '../repositories/product_variant_repository.dart';

class UpdateVariantUseCase {
  final ProductVariantRepository repository;

  UpdateVariantUseCase(this.repository);

  Future<ProductVariant> call(int variantId, ProductVariant variant,
      List<http.MultipartFile> images) async {
    return await repository.updateVariant(variantId, variant, images);
  }
}
