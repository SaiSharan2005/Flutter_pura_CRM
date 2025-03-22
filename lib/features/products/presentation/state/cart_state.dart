import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

/// Used when a single cart operation (create/update) is successful.
class CartOperationSuccess extends CartState {
  final CartEntity cart;
  const CartOperationSuccess(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// Used when multiple carts are successfully loaded.
class CartsLoadSuccess extends CartState {
  final List<CartEntity> carts;
  const CartsLoadSuccess(this.carts);

  @override
  List<Object?> get props => [carts];
}

/// Used when a list of cart items is loaded successfully.
class CartItemsLoadSuccess extends CartState {
  final List<CartItemEntity> cartItems;
  const CartItemsLoadSuccess(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
