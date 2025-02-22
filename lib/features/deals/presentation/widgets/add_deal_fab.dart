import 'package:flutter/material.dart';

class AddDealFAB extends StatelessWidget {
  const AddDealFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pushNamed('/deals/create');
      },
      backgroundColor: const Color(0xFFE41B47), // Primary Color
      elevation: 6.0, // Shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      child: const Icon(Icons.business_center, color: Colors.white),
    );
  }
}
