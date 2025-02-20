import 'package:flutter/material.dart';

class AddCartFAB extends StatelessWidget {
  const AddCartFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pushNamed('/cart');
      },
      child: const Icon(Icons.shopping_cart, color: Colors.white), // Cart Icon
      backgroundColor: const Color(0xFFE41B47), // Primary Color
      elevation: 6.0, // Add shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded FAB
      ),
    );
  }
}
