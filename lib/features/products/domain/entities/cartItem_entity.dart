import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

class CartItemEntity extends Equatable {
  final int id;
  final ProductVariant productVariant;
  final int quantity;
  final double price;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.productVariant,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'] ?? 0,
      productVariant: ProductVariant.fromJson(json['productVariant'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productVariant': productVariant.toJson(),
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  CartItemEntity copyWith({
    int? id,
    ProductVariant? productVariant,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productVariant: productVariant ?? this.productVariant,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [id, productVariant, quantity, price, totalPrice];
}
