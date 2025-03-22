import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';

abstract class CartRepository {
  Future<CartEntity> createCart();
  Future<CartEntity> addItemToCart(int cartId, int variantId, int quantity);
  Future<CartEntity> removeItemFromCart(int userId, int cartItemId);
  Future<CartEntity> updateCartItem(int userId, int cartItemId, int quantity);
  Future<List<CartEntity>> getCartsByUserId(int userId);
  Future<List<CartItemEntity>> getCartItems(int userId);
  Future<void> deleteCart(int cartId);
}
