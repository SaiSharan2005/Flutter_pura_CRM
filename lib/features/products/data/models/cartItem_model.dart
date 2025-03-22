import 'package:pura_crm/features/products/data/models/product_variant_model.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

class CartItemModel {
  final int id;
  final ProductVariantModel productVariant;
  final int quantity;
  final double price;
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.productVariant,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // Deserialize using the "productVariant" key.
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productVariant:
          ProductVariantModel.fromJson(json['productVariant'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Serialize with the key "productVariant".
  Map<String, dynamic> toJson() => {
        'id': id,
        'productVariant': productVariant.toJson(),
        'quantity': quantity,
        'price': price,
        'totalPrice': totalPrice,
      };

  // Convert to domain entity.
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productVariant: productVariant,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
    );
  }

  CartItemModel copy({
    int? id,
    ProductVariantModel? productVariant,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productVariant: productVariant ?? this.productVariant,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
