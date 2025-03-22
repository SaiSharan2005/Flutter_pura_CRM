import 'package:pura_crm/features/products/data/models/inventory_model.dart';
import 'package:pura_crm/features/products/data/models/product_variant_image_model.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    super.id,
    required super.variantName,
    required super.price,
    required super.sku,
    required super.units,
    required super.createdDate,
    super.updatedDate,
    required super.imageUrls,
    required super.inventories,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as int?,
      variantName: json['variantName'] ?? 'Unknown Variant',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      sku: json['sku'] ?? 'N/A',
      units: json['units'] ?? 'N/A',
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
      imageUrls: json['imageUrls'] != null
          ? List<ProductVariantImageModel>.from((json['imageUrls'] as List)
              .map((x) => ProductVariantImageModel.fromJson(x)))
          : [],
      inventories: json['inventories'] != null
          ? List<InventoryModel>.from((json['inventories'] as List)
              .map((x) => InventoryModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variantName': variantName,
      'price': price,
      'sku': sku,
      'units': units,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'imageUrls': imageUrls
          .map((e) => (e as ProductVariantImageModel).toJson())
          .toList(),
      'inventories':
          inventories.map((e) => (e as InventoryModel).toJson()).toList(),
    };
  }
}
