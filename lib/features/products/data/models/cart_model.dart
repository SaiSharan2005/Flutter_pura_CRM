import 'package:pura_crm/features/products/data/models/cartItem_model.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;
  final String status;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      items: (json['cartItems'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'cartItems': items.map((item) => item.toJson()).toList(),
        'status': status,
      };

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      status: status,
    );
  }
}
