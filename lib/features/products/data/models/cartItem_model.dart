import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

class CartItemModel {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      totalPrice: json['totalPrice'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'quantity': quantity,
        'price': price,
        'totalPrice': totalPrice,
      };

  // Convert CartItemModel to CartItem (domain entity)
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productId: productId,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
    );
  }
}
