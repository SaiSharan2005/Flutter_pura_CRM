import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';
import 'package:pura_crm/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/presentation/widgets/product_image_slider.dart';
import 'package:pura_crm/features/products/presentation/widgets/product_info_section.dart';
import 'package:pura_crm/features/products/presentation/widgets/variant_selector.dart';
import 'package:pura_crm/features/products/presentation/widgets/variant_details.dart';
import 'package:pura_crm/features/products/presentation/widgets/order_section.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final GetProductByIdUseCase getProductByIdUseCase;
  // We assume AddItemToCartUseCase and GetCartsByUserIdUseCase are provided via GetIt

  const ProductDetailsPage({
    Key? key,
    required this.productId,
    required this.getProductByIdUseCase,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;
  ProductVariant? _selectedVariant;
  int _currentImageIndex = 0;
  int? _latestCartId; // Latest cart id obtained from use case

  @override
  void initState() {
    super.initState();
    _productFuture = widget.getProductByIdUseCase.call(widget.productId);
    _loadLatestCart();
  }

  /// Loads the latest cart using GetCartsByUserIdUseCase.
  /// It gets the user id from SecureStorageHelper.
  void _loadLatestCart() async {
    try {
      final user = await SecureStorageHelper.getUserData();
      if (user == null) {
        print("No user data found in secure storage.");
        return;
      }
      // Access GetCartsByUserIdUseCase via GetIt.
      final carts = await GetIt.instance<GetCartsByUserIdUseCase>().call(user.id);
      if (carts.isNotEmpty) {
        // You might sort the carts if needed; here we simply take the last one.
        setState(() {
          _latestCartId = carts.last.id;
        });
      } else {
        print("No carts found for user id ${user.id}");
      }
    } catch (e) {
      print("Failed to load carts: $e");
    }
  }

  /// Adds the selected variant to the cart with the given quantity.
  void _handleAddItemToCart(ProductVariant variant, int quantity) async {
    if (_latestCartId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart not initialized yet.')),
      );
      return;
    }
    if (variant.id == null) return;
    try {
      // Access AddItemToCartUseCase via GetIt.
      final updatedCart = await GetIt.instance<AddItemToCartUseCase>()
          .call(_latestCartId!, variant.id!, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );
      // Store updated cart in secure storage.
      // await SecureStorageHelper.saveSelectedCustomer(updatedCart.toJson());
      // Optionally, you could also update _latestCartId if the cart id changes.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: $e')),
      );
    }
  }

  /// Builds the OrderSection widget.
  /// It shows a quantity input, a "Prize" input (unused), and an "Add to Cart" button.
  Widget _buildOrderSection() {
    if (_selectedVariant == null) return const SizedBox.shrink();
    if (_latestCartId == null) {
      return const Text("Loading cart details...");
    }
    return OrderSection(
      variantId: _selectedVariant!.id!,
      cartId: _latestCartId!,
      onAddToCart: (int quantity) {
        _handleAddItemToCart(_selectedVariant!, quantity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
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
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No product data found.', style: TextStyle(fontSize: 16)));
          }

          final product = snapshot.data!;
          _selectedVariant ??= product.variants.isNotEmpty ? product.variants.first : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedVariant != null) ...[
                    ProductImageSlider(
                      variant: _selectedVariant!,
                      currentIndex: _currentImageIndex,
                      onPageChanged: (index) => setState(() => _currentImageIndex = index),
                    ),
                    const SizedBox(height: 16),
                    ProductInfoSection(product: product),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Variant',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    VariantSelector(
                      variants: product.variants,
                      selectedVariant: _selectedVariant!,
                      onVariantSelected: (variant) {
                        setState(() {
                          _selectedVariant = variant;
                          _currentImageIndex = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    VariantDetails(variant: _selectedVariant!),
                    const SizedBox(height: 16),
                  ],
                  _buildOrderSection(),
                  const SizedBox(height: 16),
                  Text(
                    'Created At: ${product.createdDate.toLocal().toString().split(" ")[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A simple OrderSection widget that accepts two inputs: quantity and prize.
/// The prize input is just captured, not used anywhere.
class OrderSection extends StatelessWidget {
  final int variantId;
  final int cartId;
  final Function(int quantity) onAddToCart;

  const OrderSection({
    Key? key,
    required this.variantId,
    required this.cartId,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController quantityController = TextEditingController(text: "1");
    final TextEditingController prizeController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quantity input field.
        TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Quantity",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        // Prize input field (input captured but not used).
        TextField(
          controller: prizeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Prize",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(quantityController.text) ?? 1;
              onAddToCart(qty);
            },
            child: const Text("Add to Cart"),
          ),
        ),
      ],
    );
  }
}
