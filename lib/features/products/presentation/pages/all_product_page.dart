import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';

class AllProductsPage extends StatefulWidget {
  final GetAllProductsUseCase getAllProductsUseCase;

  const AllProductsPage({Key? key, required this.getAllProductsUseCase})
      : super(key: key);

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['New Arrivals', 'Sneakers', 'Trending'];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await widget.getAllProductsUseCase.call();
      setState(() {
        _products = response;
        _filteredProducts = _products;
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
            product.sku.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      // _selectedCategory = category;
      // _filteredProducts = _selectedCategory == 'All'
      //     // ? _products
      // : _products.where((product) => product.category == _selectedCategory).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search Bar
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

          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ..._categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => _filterByCategory(category),
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Product Grid or Loading/Error Message
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
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
                              return ProductCardView(
                                product: product,
                                onTap: (productId) {
                                  Navigator.pushNamed(
                                      context, '/product/$productId');
                                },
                              );
                            },
                          )
                        : const Center(child: Text('No products found!')),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.black,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.local_offer), label: 'Brands'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite_border), label: 'Wishlist'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
      //   ],
      // ),
    );
  }
}

class ProductCardView extends StatelessWidget {
  final Product product;
  final Function(int?)? onTap;

  const ProductCardView({Key? key, required this.product, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(product.id),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.asset(
                  'assets/logo.png', // Replace with product.image
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            // Product Info
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
                    '\$${product.price}',
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
}
