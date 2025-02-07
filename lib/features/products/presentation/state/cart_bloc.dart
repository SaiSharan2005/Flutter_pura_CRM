import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CreateCartUseCase createCartUseCase;
  final AddItemToCartUseCase addItemToCartUseCase;
  final RemoveItemFromCartUseCase removeItemFromCartUseCase;
  final RemoveCartUseCase removeCartUseCase; // Added this
  final UpdateCartItemUseCase updateCartItemUseCase;
  final GetCartsByUserIdUseCase getCartsByUserIdUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;

  CartBloc({
    required this.createCartUseCase,
    required this.addItemToCartUseCase,
    required this.removeItemFromCartUseCase,
    required this.removeCartUseCase, // Added here
    required this.updateCartItemUseCase,
    required this.getCartsByUserIdUseCase,
    required this.getCartItemsUseCase,
  }) : super(CartInitial()) {
    on<CreateCartEvent>(_onCreateCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
    on<RemoveCartEvent>(_onRemoveCart); // Added this handler
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<GetCartsByUserIdEvent>(_onGetCartsByUserId);
    on<GetCartItemsEvent>(_onGetCartItems);
  }

  Future<void> _onCreateCart(
      CreateCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await createCartUseCase(event.userId);
      emit(CartSuccess(cart));
    } catch (e) {
      emit(CartError('Failed to create cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddItemToCart(
      AddItemToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await addItemToCartUseCase(
          event.cartId, event.productId, event.quantity);
      emit(CartSuccess(cart));
    } catch (e) {
      emit(CartError('Failed to add item: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart =
          await removeItemFromCartUseCase(event.userId, event.cartItemId);
      emit(CartSuccess(cart));
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  // New event handler to remove a cart.
  Future<void> _onRemoveCart(
      RemoveCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await removeCartUseCase(event.cartId); // Delete the cart
      final carts = await getCartsByUserIdUseCase(event.userId);
      emit(CartListSuccess(carts));
    } catch (e) {
      emit(CartError('Failed to remove cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartItem(
      UpdateCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await updateCartItemUseCase(
          event.userId, event.cartItemId, event.quantity);
      emit(CartSuccess(cart));
    } catch (e) {
      emit(CartError('Failed to update item: ${e.toString()}'));
    }
  }

  Future<void> _onGetCartsByUserId(
      GetCartsByUserIdEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final carts = await getCartsByUserIdUseCase(event.userId);
      emit(CartListSuccess(carts));
    } catch (e) {
      emit(CartError('Failed to fetch carts: ${e.toString()}'));
    }
  }

  Future<void> _onGetCartItems(
      GetCartItemsEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await getCartItemsUseCase(event.userId);
      emit(CartItemsSuccess(cartItems));
    } catch (e) {
      emit(CartError('Failed to fetch items: ${e.toString()}'));
    }
  }
}
