import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/inventory.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant_image.dart';

class ProductVariant extends Equatable {
  final int? id;
  final String variantName;
  final double price;
  final String sku;
  final String units;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final List<ProductVariantImage> imageUrls;
  final List<Inventory> inventories;

  const ProductVariant({
    this.id,
    required this.variantName,
    required this.price,
    required this.sku,
    required this.units,
    required this.createdDate,
    this.updatedDate,
    required this.imageUrls,
    required this.inventories,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as int?,
      variantName: json['variantName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'] ?? '',
      units: json['units'] ?? '',
      createdDate: DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'] as String)
          : null,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      inventories: (json['inventories'] as List<dynamic>?)
              ?.map((e) => Inventory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'imageUrls': imageUrls.map((e) => e.toJson()).toList(),
      'inventories': inventories.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        variantName,
        price,
        sku,
        units,
        createdDate,
        updatedDate,
        imageUrls,
        inventories,
      ];
}
