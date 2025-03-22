import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateCartEvent extends CartEvent {
  final int userId;

  CreateCartEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddItemToCartEvent extends CartEvent {
  final int cartId;
  final int variantId; // Updated from productId to variantId.
  final int quantity;

  AddItemToCartEvent(this.cartId, this.variantId, this.quantity);

  @override
  List<Object?> get props => [cartId, variantId, quantity];
}

class RemoveItemFromCartEvent extends CartEvent {
  final int userId;
  final int cartItemId;

  RemoveItemFromCartEvent(this.userId, this.cartItemId);

  @override
  List<Object?> get props => [userId, cartItemId];
}

class UpdateCartItemEvent extends CartEvent {
  final int userId;
  final int cartItemId;
  final int quantity;

  UpdateCartItemEvent(this.userId, this.cartItemId, this.quantity);

  @override
  List<Object?> get props => [userId, cartItemId, quantity];
}

class GetCartsByUserIdEvent extends CartEvent {
  final int userId;

  GetCartsByUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetCartItemsEvent extends CartEvent {
  final int userId;

  GetCartItemsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RemoveCartEvent extends CartEvent {
  final int cartId;
  final int userId;

  RemoveCartEvent({required this.cartId, required this.userId});

  @override
  List<Object?> get props => [cartId, userId];
}
