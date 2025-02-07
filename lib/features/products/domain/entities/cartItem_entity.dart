import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // fromJson method to deserialize the JSON data
  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  // toJson method to serialize the CartItemEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  // copyWith method to modify immutable properties
  CartItemEntity copyWith({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props =>
      [id, productId, productName, quantity, price, totalPrice];
}
