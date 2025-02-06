import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/products/data/models/cart_model.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiClient apiClient;

  CartRepositoryImpl(this.apiClient);

  @override
  Future<CartEntity> createCart(int userId) async {
    try {
      final response =
          await apiClient.post('/cart/create', jsonEncode({'userId': userId}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cartModel = CartModel.fromJson(data);
        return cartModel.toEntity();
      } else {
        throw Exception('Failed to create cart: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error creating cart: $error');
    }
  }

  @override
  Future<CartEntity> addItemToCart(
      int userId, int productId, int quantity) async {
    try {
      final response = await apiClient.post(
        '/cart/add',
        jsonEncode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cartModel = CartModel.fromJson(data);
        return cartModel.toEntity();
      } else {
        throw Exception('Failed to add item to cart: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error adding item to cart: $error');
    }
  }

  @override
  Future<CartEntity> removeItemFromCart(int userId, int cartItemId) async {
    try {
      final response = await apiClient.delete(
        '/cart/remove',
        body: jsonEncode({'userId': userId, 'cartItemId': cartItemId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cartModel = CartModel.fromJson(data);
        return cartModel.toEntity();
      } else {
        throw Exception(
            'Failed to remove item from cart: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error removing item from cart: $error');
    }
  }

  @override
  Future<CartEntity> updateCartItem(
      int userId, int cartItemId, int quantity) async {
    try {
      final response = await apiClient.put(
        '/cart/update',
        jsonEncode({
          'userId': userId,
          'cartItemId': cartItemId,
          'quantity': quantity,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cartModel = CartModel.fromJson(data);
        return cartModel.toEntity();
      } else {
        throw Exception('Failed to update cart item: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error updating cart item: $error');
    }
  }

  @override
  Future<List<CartEntity>> getCartsByUserId(int userId) async {
    try {
      final response = await apiClient.get('/cart/user/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((cartJson) => CartModel.fromJson(cartJson).toEntity())
            .toList();
      } else {
        throw Exception(
            'Failed to fetch carts for user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching carts for user: $error');
    }
  }

  @override
  Future<List<CartItemEntity>> getCartItems(int userId) async {
    try {
      final response = await apiClient.get('/cart/items/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((cartItemJson) => CartItemEntity.fromJson(cartItemJson))
            .toList();
      } else {
        throw Exception('Failed to fetch cart items: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching cart items: $error');
    }
  }
}
