import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';

class ProductDetailsPage extends StatefulWidget {
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetCartsByUserIdUseCase getCartsByUserIdUseCase; // ADD THIS

  final int productId;

  const ProductDetailsPage({
    Key? key,
    required this.getProductByIdUseCase,
    required this.getCartsByUserIdUseCase, // ADD THIS

    required this.productId,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.getProductByIdUseCase.call(widget.productId);
  }

  void _addToLatestCart() async {
    try {
      final userData = await SecureStorageHelper.getUserData();
      if (userData == null || userData.id == null) {
        print("User not logged in or user ID not available.");
        return;
      }
      final userId = userData.id;

      // Fetch the latest cart for the user
      final latestCarts = await widget.getCartsByUserIdUseCase(userId);

      if (latestCarts.isNotEmpty) {
        final latestCart = latestCarts.last; // Get the most recent cart

        // Assuming quantity is 1; you can modify this to take user input.
        const quantity = 1;

        // Add the product to the latest cart
        context
            .read<CartBloc>()
            .add(AddItemToCartEvent(latestCart.id, widget.productId, quantity)
                //   userId: userId,
                //   productId: widget.productId,
                //   quantity: quantity,
                // ),
                );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added to Cart ID: ${latestCart.id}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No available cart. Please create one first.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    }
    void _addToLatestCart() async {
      try {
        final userId =
            1; // Assuming userId is 1; replace with actual logic to get user ID.

        // Fetch the latest cart for the user
        final latestCarts = await widget.getCartsByUserIdUseCase(userId);

        if (latestCarts.isNotEmpty) {
          final latestCart = latestCarts.last; // Get the most recent cart

          // Assuming quantity is 1; you can modify this to take user input.
          const quantity = 1;

          // Add the product to the latest cart
          context
              .read<CartBloc>()
              .add(AddItemToCartEvent(userId, widget.productId, quantity));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Product added to Cart ID: ${latestCart.id}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No available cart. Please create one first.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No product data found.',
                  style: TextStyle(fontSize: 16)),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product),
                  const SizedBox(height: 16),
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.productStatus == 'Available'
                        ? 'In stock'
                        : 'Out of stock',
                    style: TextStyle(
                      fontSize: 16,
                      color: product.productStatus == 'Available'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSpecifications(product),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/logo.png'), // Replace with product image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecifications(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Size', 'One size'),
        _buildDetailRow('Dimensions', product.dimensions ?? 'N/A'),
        _buildDetailRow('Weight', '${product.weight} lbs'),
        _buildDetailRow(
            'Warranty',
            product.warrantyPeriod != null
                ? '${product.warrantyPeriod} months'
                : 'Lifetime'),
        _buildDetailRow('SKU', product.sku ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _addToLatestCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add to cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
