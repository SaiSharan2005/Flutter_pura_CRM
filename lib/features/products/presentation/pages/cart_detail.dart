import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';
import 'package:pura_crm/features/products/domain/repositories/cart_repository.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class CartDetailsPage extends StatefulWidget {
  /// If you already have the cart data, pass it here.
  final CartEntity? initialCart;

  /// Otherwise, route should be "/cart/detail/{id}" and we'll fetch by this.
  final int? cartId;

  const CartDetailsPage({
    Key? key,
    this.initialCart,
    this.cartId,
  }) : super(key: key);

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  late Future<List<dynamic>> _cartAndProductsFuture;

  /// Mutable in-memory copy of cart items.
  late List<CartItemEntity> localCartItems;

  /// Original quantities for change detection.
  late List<int> originalQuantities;

  /// IDs of items removed entirely.
  final List<int> removedItemIds = [];

  /// Group variants by product ID.
  final Map<int, List<CartItemEntity>> productToVariants = {};

  /// ← Prevent re-initializing on every build.
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Prepare cartFuture
    Future<CartEntity> cartFuture;
    if (widget.initialCart != null) {
      cartFuture = Future.value(widget.initialCart!);
    } else if (widget.cartId != null) {
      cartFuture =
          GetCartByIdUseCase(GetIt.I<CartRepository>())(widget.cartId!);
    } else {
      cartFuture = Future.error('No cartId provided');
    }

    // 2️⃣ Prepare productsFuture
    final productsFuture = GetIt.I<GetAllProductsUseCase>()();

    // 3️⃣ Combine both
    _cartAndProductsFuture = Future.wait([cartFuture, productsFuture]);
  }

  /// Seed localCartItems and originalQuantities once.
  void _initializeLocalLists(CartEntity cart) {
    localCartItems = (cart.items ?? [])
        .map((i) => i.copyWith())
        .toList();
    originalQuantities =
        (cart.items ?? []).map((i) => i.quantity).toList();
  }

  /// Group each variant-item under its parent product.
  void _organizeByProduct(
      List<CartItemEntity> items,
      Map<int, Product> variantToProductMap,
  ) {
    productToVariants.clear();
    for (var item in items) {
      final vid = item.productVariant.id;
      if (vid != null) {
        final prod = variantToProductMap[vid];
        if (prod?.id != null) {
          productToVariants.putIfAbsent(prod!.id!, () => []).add(item);
        }
      }
    }
  }

  void _increaseQuantity(CartItemEntity item) {
    setState(() {
      final idx = localCartItems.indexWhere((i) => i.id == item.id);
      if (idx == -1) return;
      final updated = localCartItems[idx]
          .copyWith(quantity: localCartItems[idx].quantity + 1);
      localCartItems[idx] = updated;

      // also update in grouped map
      for (var variants in productToVariants.values) {
        final vi = variants.indexWhere((v) => v.id == item.id);
        if (vi != -1) {
          variants[vi] = updated;
          break;
        }
      }
    });
  }

  void _decreaseQuantity(CartItemEntity item) {
    setState(() {
      final idx = localCartItems.indexWhere((i) => i.id == item.id);
      if (idx == -1) return;
      final curr = localCartItems[idx];
      if (curr.quantity > 1) {
        final updated = curr.copyWith(quantity: curr.quantity - 1);
        localCartItems[idx] = updated;
        for (var variants in productToVariants.values) {
          final vi = variants.indexWhere((v) => v.id == item.id);
          if (vi != -1) {
            variants[vi] = updated;
            break;
          }
        }
      } else {
        // remove entirely
        removedItemIds.add(curr.id);
        localCartItems.removeAt(idx);
        originalQuantities.removeAt(idx);
        for (var pid in productToVariants.keys.toList()) {
          productToVariants[pid]!.removeWhere((v) => v.id == item.id);
          if (productToVariants[pid]!.isEmpty) {
            productToVariants.remove(pid);
          }
        }
      }
    });
  }

  void _saveChanges(CartEntity baseCart) {
    final bloc = context.read<CartBloc>();
    bool hasChange = false;

    // dispatch removals
    for (var rid in removedItemIds) {
      hasChange = true;
      bloc.add(RemoveItemFromCartEvent(baseCart.userId, rid));
    }
    // dispatch updates
    for (var i = 0; i < localCartItems.length; i++) {
      final m = localCartItems[i];
      if (m.quantity != originalQuantities[i]) {
        hasChange = true;
        bloc.add(UpdateCartItemEvent(
          baseCart.userId,
          m.id,
          m.quantity,
        ));
      }
    }

    if (!hasChange) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
      return;
    }

    if (localCartItems.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, '/cart', (r) => false);
    } else {
      Navigator.pop(context);
    }
  }

  double _calculateTotal() =>
      localCartItems.fold(0.0, (s, i) => s + i.price * i.quantity);

  double _calculateProductTotal(List<CartItemEntity> items) =>
      items.fold(0.0, (s, i) => s + i.price * i.quantity);

  String? _getProductMainImage(
      Product product,
      List<CartItemEntity> variants,
  ) {
    for (var v in variants) {
      if (v.productVariant.imageUrls.isNotEmpty) {
        return v.productVariant.imageUrls.first.imageUrl;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return FutureBuilder<List<dynamic>>(
      future: _cartAndProductsFuture,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snap.error}')),
          );
        }

        // 1️⃣ unpack
        final cart = snap.data![0] as CartEntity;
        final products = snap.data![1] as List<Product>;

        // 2️⃣ init once
        if (!_hasInitialized) {
          _initializeLocalLists(cart);
          _hasInitialized = true;
        }

        // 3️⃣ build lookups & group
        final variantToProduct = <int, Product>{};
        for (var p in products) {
          for (var v in p.variants) {
            if (v.id != null) variantToProduct[v.id!] = p;
          }
        }
        _organizeByProduct(localCartItems, variantToProduct);

        return BlocListener<CartBloc, CartState>(
          listener: (c, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(c).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Cart Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // ── Header ───────────────────────────
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cart #${cart.id}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(cart.status ?? '',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // ── Items ────────────────────────────
                  Expanded(
                    child: productToVariants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text('Your cart is empty',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54)),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                      context, '/products', (r) => false),
                                  child: const Text('Browse Products',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: productToVariants.length,
                            itemBuilder: (ctx, idx) {
                              final pid =
                                  productToVariants.keys.elementAt(idx);
                              final variants = productToVariants[pid]!;
                              final prod = variantToProduct[
                                  variants.first.productVariant.id]!;
                              final img = _getProductMainImage(prod, variants);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product header
                                      Row(
                                        children: [
                                          if (img != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                img,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else
                                            Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(prod.productName,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${variants.length} variant${variants.length > 1 ? 's' : ''}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[700]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isSmall)
                                            Text(
                                              'Subtotal: \$${_calculateProductTotal(variants).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: primaryColor),
                                            ),
                                        ],
                                      ),

                                      if (isSmall)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            'Subtotal: \$${_calculateProductTotal(variants).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: primaryColor),
                                          ),
                                        ),

                                      const Divider(height: 24),

                                      // Each variant + controls
                                      ...variants.map((item) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(item
                                                      .productVariant
                                                      .variantName)),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.red),
                                                onPressed: () =>
                                                    _decreaseQuantity(item),
                                              ),
                                              Text('${item.quantity}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.green),
                                                onPressed: () =>
                                                    _increaseQuantity(item),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // ── Total & Save ─────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('\$${_calculateTotal().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _saveChanges(cart),
                              child: const Text('Save Changes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
