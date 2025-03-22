import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';

class OrderSection extends StatefulWidget {
  final int variantId; // Represents the variant ID
  final int cartId; // Assume the cart is already created

  const OrderSection({
    Key? key,
    required this.variantId,
    required this.cartId,
  }) : super(key: key);

  @override
  _OrderSectionState createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final text = _quantityController.text.trim();
    if (text.isEmpty) {
      _showMessage("Please enter a quantity.");
      return;
    }

    final quantity = int.tryParse(text);
    if (quantity == null || quantity <= 0) {
      _showMessage("Invalid quantity.");
      return;
    }

    // Dispatch event to add item to cart.
    // Your CartBloc should then update its state with the latest cart and items.
    context.read<DemoCartBloc>().add(
          AddItemToCartEvent(widget.cartId, widget.variantId, quantity),
        );

    _showMessage("Item added to cart.");
    _quantityController.clear();

    // Optionally, if you need to explicitly refresh the cart after adding,
    // you could dispatch a refresh event here (if you have access to the userId).
    // For example:
    // context.read<CartBloc>().add(GetCartItemsEvent(userId));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Quantity',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE41B47),
            ),
            onPressed: _addToCart,
            child: const Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
