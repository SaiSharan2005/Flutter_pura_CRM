import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

class CartEntity extends Equatable {
  final int id;
  final int userId;
  final List<CartItemEntity> items;
  final String status;

  const CartEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
  });

  factory CartEntity.fromJson(Map<String, dynamic> json) {
    return CartEntity(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) =>
                  CartItemEntity.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, userId, items, status];
}
