import 'dart:convert';
import 'package:pura_crm/features/products/data/models/product_variant_model.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.productName,
    required super.description,
    required super.productStatus,
    required super.createdDate,
    required super.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      productName: json['productName'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      productStatus: json['productStatus'] ?? 'Unavailable',
      createdDate: DateTime.parse(json['createdDate']),
      variants: json['variants'] != null
          ? List<ProductVariantModel>.from((json['variants'] as List)
              .map((x) => ProductVariantModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'description': description,
      'productStatus': productStatus,
      'createdDate': createdDate.toIso8601String(),
      'variants':
          variants.map((e) => (e as ProductVariantModel).toJson()).toList(),
    };
  }
}
