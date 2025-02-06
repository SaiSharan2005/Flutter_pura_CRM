import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // fromJson method to deserialize the JSON data
  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['totalPrice'],
    );
  }

  // Optional toJson method to serialize the CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  @override
  List<Object?> get props => [id, productId, quantity, price, totalPrice];
}
