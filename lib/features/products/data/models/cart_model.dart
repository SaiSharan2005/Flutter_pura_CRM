import 'package:pura_crm/features/products/data/models/cartItem_model.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    int userId;
    if (json.containsKey('userId')) {
      userId = json['userId'] ?? 0;
    } else if (json.containsKey('user') && json['user'] != null) {
      userId = json['user']['id'] ?? 0;
    } else {
      userId = 0;
    }

    return CartModel(
      id: json['id'],
      userId: userId,
      items: json['cartItems'] != null
          ? (json['cartItems'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList()
          : [],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'cartItems': items.map((item) => item.toJson()).toList(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
