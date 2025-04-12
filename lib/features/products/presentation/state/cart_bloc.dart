import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CreateCartUseCase createCartUseCase;
  final AddItemToCartUseCase addItemToCartUseCase;
  final RemoveItemFromCartUseCase removeItemFromCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final GetCartsByUserIdUseCase getCartsByUserIdUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final RemoveCartUseCase removeCartUseCase;

  CartBloc({
    required this.createCartUseCase,
    required this.addItemToCartUseCase,
    required this.removeItemFromCartUseCase,
    required this.updateCartItemUseCase,
    required this.getCartsByUserIdUseCase,
    required this.getCartItemsUseCase,
    required this.removeCartUseCase,
  }) : super(const CartInitial()) {
    on<CreateCartEvent>(_onCreateCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<GetCartsByUserIdEvent>(_onGetCartsByUserId);
    on<GetCartItemsEvent>(_onGetCartItems);
    on<RemoveCartEvent>(_onRemoveCart);
  }

  Future<void> _onCreateCart(CreateCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cart = await createCartUseCase.call();
      emit(CartOperationSuccess(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddItemToCart(AddItemToCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cart = await addItemToCartUseCase.call(event.cartId, event.variantId, event.quantity);
      emit(CartOperationSuccess(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cart = await removeItemFromCartUseCase.call(event.userId, event.cartItemId);
      emit(CartOperationSuccess(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cart = await updateCartItemUseCase.call(event.userId, event.cartItemId, event.quantity);
      emit(CartOperationSuccess(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onGetCartsByUserId(GetCartsByUserIdEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final carts = await getCartsByUserIdUseCase.call(event.userId);
      emit(CartsLoadSuccess(carts));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onGetCartItems(GetCartItemsEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartItems = await getCartItemsUseCase.call(event.userId);
      emit(CartItemsLoadSuccess(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveCart(RemoveCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await removeCartUseCase.call(event.cartId);
      // Optionally, you could emit a state indicating the cart was removed.
      emit(const CartsLoadSuccess([]));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
