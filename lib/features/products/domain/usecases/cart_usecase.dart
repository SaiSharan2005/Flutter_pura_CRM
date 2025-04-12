import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/repositories/cart_repository.dart';

class CreateCartUseCase {
  final CartRepository repository;

  CreateCartUseCase(this.repository);

  Future<CartEntity> call() async {
    // Since the repository.createCart() does not require a userId, we removed it.
    return await repository.createCart();
  }
}

class AddItemToCartUseCase {
  final CartRepository repository;

  AddItemToCartUseCase(this.repository);

  Future<CartEntity> call(int cartId, int variantId, int quantity) async {
    // Changed the first parameter to cartId and renamed productId to variantId.
    return await repository.addItemToCart(cartId, variantId, quantity);
  }
}

class RemoveItemFromCartUseCase {
  final CartRepository repository;

  RemoveItemFromCartUseCase(this.repository);

  Future<CartEntity> call(int userId, int cartItemId) async {
    return await repository.removeItemFromCart(userId, cartItemId);
  }
}

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  Future<CartEntity> call(int userId, int cartItemId, int quantity) async {
    // Updated return type to CartEntity to match the repository method.
    return await repository.updateCartItem(userId, cartItemId, quantity);
  }
}

class GetCartsByUserIdUseCase {
  final CartRepository repository;

  GetCartsByUserIdUseCase(this.repository);

  Future<List<CartEntity>> call(int userId) async {
    return await repository.getCartsByUserId(userId);
  }
}

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<List<CartItemEntity>> call(int userId) async {
    return await repository.getCartItems(userId);
  }
}

class RemoveCartUseCase {
  final CartRepository repository;

  RemoveCartUseCase(this.repository);

  Future<void> call(int cartId) async {
    await repository.deleteCart(cartId);
  }
}
class GetCartByIdUseCase {
  final CartRepository repository;

  GetCartByIdUseCase(this.repository);

  Future<CartEntity> call(int cartId) async {
    return await repository.getCartById(cartId);
  }
}
