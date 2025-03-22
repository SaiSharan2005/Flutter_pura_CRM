import 'package:pura_crm/features/products/domain/entities/product_variant_image.dart';

class ProductVariantImageModel extends ProductVariantImage {
  const ProductVariantImageModel({super.id, required super.imageUrl});

  factory ProductVariantImageModel.fromJson(dynamic json) {
    if (json is String) {
      // If the API returns a string instead of an object.
      return ProductVariantImageModel(imageUrl: json);
    } else if (json is Map<String, dynamic>) {
      return ProductVariantImageModel(
        id: json['id'] as int?,
        imageUrl: json['imageUrl'] ?? '',
      );
    } else {
      throw Exception("Invalid ProductVariantImage data");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }
}
