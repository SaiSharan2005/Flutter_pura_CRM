import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class CartDetailsPage extends StatefulWidget {
  final CartEntity cart;
  const CartDetailsPage({super.key, required this.cart});

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  /// Local copy of the cart items for modifications.
  late List<CartItemEntity> localCartItems;

  /// Copy of original quantities to detect modifications.
  late List<int> originalQuantities;

  /// Track IDs of items removed from the cart.
  final List<int> removedItemIds = [];

  @override
  void initState() {
    super.initState();
    // If widget.cart.items is null, default to an empty list.
    localCartItems =
        (widget.cart.items ?? []).map((item) => item.copyWith()).toList();
    originalQuantities =
        (widget.cart.items ?? []).map((item) => item.quantity).toList();
  }

  void _increaseQuantity(int index) {
    setState(() {
      final currentQuantity = localCartItems[index].quantity;
      localCartItems[index] = localCartItems[index].copyWith(
        quantity: currentQuantity + 1,
      );
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      final currentQuantity = localCartItems[index].quantity;
      if (currentQuantity > 1) {
        localCartItems[index] = localCartItems[index].copyWith(
          quantity: currentQuantity - 1,
        );
      } else {
        removedItemIds.add(localCartItems[index].id);
        localCartItems.removeAt(index);
        originalQuantities.removeAt(index);
      }
    });
  }

  /// Dispatch update and removal events based on changes.
  void _saveChanges() {
    final bloc = context.read<DemoCartBloc>();
    bool hasChange = false;

    // Process removed items.
    for (var removedId in removedItemIds) {
      hasChange = true;
      bloc.add(RemoveItemFromCartEvent(widget.cart.userId, removedId));
    }

    // Process quantity updates.
    for (int i = 0; i < localCartItems.length; i++) {
      final modifiedItem = localCartItems[i];
      final originalQuantity = originalQuantities[i];
      if (modifiedItem.quantity != originalQuantity) {
        hasChange = true;
        bloc.add(UpdateCartItemEvent(
          widget.cart.userId,
          modifiedItem.id,
          modifiedItem.quantity,
        ));
      }
    }

    if (!hasChange) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
    } else {
      // If the cart is empty after removals, navigate back to the cart page.
      if (localCartItems.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false);
      } else {
        Navigator.pop(context);
      }
    }
  }

  /// Calculate the total sum of the cart.
  double _calculateTotalSum() {
    double sum = 0;
    for (var item in localCartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);

    return BlocListener<DemoCartBloc, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text(
            'Cart Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            // Cart header.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart #${widget.cart.id}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.cart.status ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            // List of cart items.
            Expanded(
              child: localCartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No items in cart.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: localCartItems.length,
                      itemBuilder: (context, index) {
                        final item = localCartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Product image and tap action.
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/product/${item.productVariant.id}',
                                      );
                                    },
                                    child: Image.network(
                                      item.productVariant.imageUrls.first
                                          .imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Product details.
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/product/${item.productVariant.id}',
                                          );
                                        },
                                        child: Text(
                                          item.productVariant.variantName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Price: \$${item.price.toStringAsFixed(2)}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                // Quantity controls and total price.
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                          onPressed: () =>
                                              _decreaseQuantity(index),
                                        ),
                                        Text(
                                          "${item.quantity}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green,
                                            size: 28,
                                          ),
                                          onPressed: () =>
                                              _increaseQuantity(index),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Total sum and Save Changes button.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Sum:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${_calculateTotalSum().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _saveChanges,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
