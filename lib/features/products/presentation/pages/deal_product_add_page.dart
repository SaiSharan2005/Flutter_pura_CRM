import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';

class DealProductAddPage extends StatefulWidget {
  final Customer customer;
  final GetAllProductsUseCase getAllProductsUseCase;
  final CreateCartUseCase createCartUseCase;
  final AddItemToCartUseCase addItemToCartUseCase;

  const DealProductAddPage({
    Key? key,
    required this.customer,
    required this.getAllProductsUseCase,
    required this.createCartUseCase,
    required this.addItemToCartUseCase,
  }) : super(key: key);

  @override
  _DealProductAddPageState createState() => _DealProductAddPageState();
}

class _DealProductAddPageState extends State<DealProductAddPage> {
  CartEntity? _cart;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  // Primary color.
  final Color primaryColor = const Color(0xFFE41B47);

  @override
  void initState() {
    super.initState();
    _createCart();
    _fetchProducts();
  }

  Future<void> _createCart() async {
    try {
      final cart = await widget.createCartUseCase.call();
      setState(() {
        _cart = cart;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create cart: $e';
      });
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final products = await widget.getAllProductsUseCase.call();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.productName.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  // When a product is tapped, add its first variant (if available) to the cart.
  void _handleAddItem(Product product) async {
    if (_cart == null) return;
    if (product.variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No variants available for this product.')),
      );
      return;
    }
    final variantId = product.variants.first.id;
    if (variantId == null) return;
    try {
      final updatedCart =
          await widget.addItemToCartUseCase.call(_cart!.id, variantId, 1);
      setState(() {
        _cart = updatedCart;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item')),
      );
    }
  }

  void _goToCartView() {
    if (_cart != null) {
      Navigator.pushNamed(context, '/deal/cart/view', arguments: _cart);
    }
  }

  Widget _buildProductCard(Product product) {
    String? imageUrl;
    if (product.variants.isNotEmpty &&
        product.variants.first.imageUrls.isNotEmpty) {
      imageUrl = product.variants.first.imageUrls.first.imageUrl;
    }
    // Price (from first variant, if any)
    String priceText = product.variants.isNotEmpty
        ? '\$${product.variants.first.price.toStringAsFixed(2)}'
        : 'N/A';

    return GestureDetector(
      onTap: () => _handleAddItem(product),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceText,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _filterProducts,
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            // Product Grid.
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isNotEmpty
                      ? GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return _buildProductCard(product);
                          },
                        )
                      : const Center(child: Text('No products found!')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _goToCartView,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: const Text(
            'Go To Cart',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
