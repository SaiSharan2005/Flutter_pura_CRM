import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

class CartEntity extends Equatable {
  final int id;
  final int userId;
  final List<CartItemEntity> items;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CartEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory CartEntity.fromJson(Map<String, dynamic> json) {
    int userId;
    if (json.containsKey('userId')) {
      userId = json['userId'] ?? 0;
    } else if (json.containsKey('user') && json['user'] != null) {
      userId = json['user']['id'] ?? 0;
    } else {
      userId = 0;
    }

    return CartEntity(
      id: json['id'] ?? 0,
      userId: userId,
      items: json['cartItems'] != null
          ? (json['cartItems'] as List<dynamic>)
              .map((item) =>
                  CartItemEntity.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cartItems': items.map((item) => item.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, userId, items, status, createdAt, updatedAt];
}
