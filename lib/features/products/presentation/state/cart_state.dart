import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartEntity cart;

  CartSuccess(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartItemsSuccess extends CartState {
  final List<CartItemEntity> cartItems;

  CartItemsSuccess(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartListSuccess extends CartState {
  final List<CartEntity> carts;

  CartListSuccess(this.carts);

  @override
  List<Object?> get props => [carts];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object?> get props => [message];
}
