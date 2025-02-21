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
  /// Create a local copy of the cart items so that modifications can be saved later.
  late List<CartItemEntity> localCartItems;

  /// Keep a copy of the original quantities to check for modifications.
  late List<int> originalQuantities;

  /// Keep track of items that are removed from the cart.
  final List<int> removedItemIds = [];

  @override
  void initState() {
    super.initState();
    // If items is null, default to an empty list.
    localCartItems =
        (widget.cart.items ?? []).map((item) => item.copyWith()).toList();
    originalQuantities =
        (widget.cart.items ?? []).map((item) => item.quantity ?? 0).toList();
  }

  void _increaseQuantity(int index) {
    setState(() {
      // Use default value if quantity is null.
      int currentQuantity = localCartItems[index].quantity ?? 0;
      localCartItems[index] = localCartItems[index].copyWith(
        quantity: currentQuantity + 1,
      );
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      int currentQuantity = localCartItems[index].quantity ?? 0;
      // If the quantity is greater than 1, simply decrease it.
      if (currentQuantity > 1) {
        localCartItems[index] = localCartItems[index].copyWith(
          quantity: currentQuantity - 1,
        );
      } else {
        // If the quantity is 1 (or null) and the user decrements, remove the item.
        removedItemIds.add(localCartItems[index].id);
        localCartItems.removeAt(index);
        originalQuantities.removeAt(index);
      }
    });
  }

  /// Dispatch update and removal events for cart items based on the modifications.
  void _saveChanges() {
    final bloc = context.read<CartBloc>();
    bool hasChange = false;

    // Dispatch removal events for all items that were removed.
    for (var removedId in removedItemIds) {
      hasChange = true;
      bloc.add(RemoveItemFromCartEvent(widget.cart.userId, removedId));
    }

    // Dispatch update events for items that remain but with a modified quantity.
    for (int i = 0; i < localCartItems.length; i++) {
      final modifiedItem = localCartItems[i];
      final originalQuantity = originalQuantities[i];
      if ((modifiedItem.quantity ?? 0) != originalQuantity) {
        hasChange = true;
        bloc.add(UpdateCartItemEvent(
          widget.cart.userId,
          modifiedItem.id,
          modifiedItem.quantity ?? 0,
        ));
      }
    }

    if (!hasChange) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
    } else {
      // If the cart is empty after removal, redirect to the cart page.
      if (localCartItems.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/cart', (route) => false);
      } else {
        Navigator.pop(context);
      }
    }
  }

  /// Calculate the total sum based on the current local items.
  double _calculateTotalSum() {
    double sum = 0;
    for (var item in localCartItems) {
      // Use default values for price and quantity if they are null.
      double price = item.price ?? 0.0;
      int quantity = item.quantity ?? 0;
      sum += price * quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // Define your primary color.
    const primaryColor = Color(0xFFE41B47);

    return BlocListener<CartBloc, CartState>(
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Column(
          children: [
            // Header with minimal cart details.
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
                                // Left: Product Image and Details.
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigate to product detail page.
                                      Navigator.pushNamed(
                                        context,
                                        '/product/${item.product.id}',
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/logo.png', // Replace with the actual product image.
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Expanded product details.
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/product/${item.product.id}',
                                          );
                                        },
                                        child: Text(
                                          item.product.productName ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Price: \$${(item.price ?? 0.0).toStringAsFixed(2)}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right: Quantity controls and total price.
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
                                          "${item.quantity ?? 0}",
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
                                      "\$${((item.price ?? 0.0) * (item.quantity ?? 0)).toStringAsFixed(2)}",
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
