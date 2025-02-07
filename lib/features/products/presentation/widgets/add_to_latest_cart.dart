// import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
// import 'package:pura_crm/features/products/presentation/state/cart_event.dart';

// void _addToLatestCart() async {
//   try {
//     final userId = 1; // Assuming userId is 1; replace with actual logic to get user ID.
    
//     // Fetch the latest cart for the user
//     final latestCarts = await widget.getCartsByUserIdUseCase(userId);
    
//     if (latestCarts.isNotEmpty) {
//       final latestCart = latestCarts.last; // Get the most recent cart
      
//       // Assuming quantity is 1; you can modify this to take user input.
//       const quantity = 1;

//       // Add the product to the latest cart
//       context.read<CartBloc>().add(
//         AddItemToCartEvent(
//           userId: userId,
//           productId: widget.productId,
//           quantity: quantity,
//         ),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product added to Cart ID: ${latestCart.id}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No available cart. Please create one first.')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error adding to cart: $e')),
//     );
//   }
// void _addToLatestCart() async {
//   try {
//     final userId = 1; // Assuming userId is 1; replace with actual logic to get user ID.
    
//     // Fetch the latest cart for the user
//     final latestCarts = await widget.getCartsByUserIdUseCase(userId);
    
//     if (latestCarts.isNotEmpty) {
//       final latestCart = latestCarts.last; // Get the most recent cart
      
//       // Assuming quantity is 1; you can modify this to take user input.
//       const quantity = 1;

//       // Add the product to the latest cart
//       context.read<CartBloc>().add(
//         AddItemToCartEvent(
//           userId: userId,
//           productId: widget.productId,
//           quantity: quantity,
//         ),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product added to Cart ID: ${latestCart.id}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No available cart. Please create one first.')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error adding to cart: $e')),
//     );
//   }
// }

// }

