import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';

class CartItemEntity extends Equatable {
  final int id;
  final ProductModel product;
  final int quantity;
  final double price;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // fromJson method to deserialize the JSON data
  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'] ?? 0,
      product: ProductModel.fromJson(
          json['product'] ?? {}), // Deserialize product properly
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // toJson method to serialize the CartItemEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(), // Serialize product properly
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  // copyWith method to modify immutable properties
  CartItemEntity copyWith({
    int? id,
    ProductModel? product,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product, // Copying product correctly
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, price, totalPrice];
}
