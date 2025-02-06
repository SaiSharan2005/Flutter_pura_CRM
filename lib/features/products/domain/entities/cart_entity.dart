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

  @override
  List<Object?> get props => [id, userId, items, status];
}
