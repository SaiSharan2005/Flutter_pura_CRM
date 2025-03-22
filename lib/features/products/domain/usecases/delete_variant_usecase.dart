import '../repositories/product_variant_repository.dart';

class DeleteVariantUseCase {
  final ProductVariantRepository repository;

  DeleteVariantUseCase(this.repository);

  Future<void> call(int variantId) async {
    await repository.deleteVariant(variantId);
  }
}
