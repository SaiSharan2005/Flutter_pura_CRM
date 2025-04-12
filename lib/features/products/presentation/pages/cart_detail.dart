import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';
import 'package:pura_crm/features/products/domain/repositories/cart_repository.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

// New imports for deals and secure storage:
import 'package:pura_crm/features/deals/domain/usecases/create_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';

class CartDetailsPage extends StatefulWidget {
  /// If you already have the cart data, pass it here.
  final CartEntity? initialCart;

  /// Otherwise, route should be "/cart/detail/{id}" and we'll fetch by this.
  final int? cartId;

  const CartDetailsPage({
    Key? key,
    this.initialCart,
    this.cartId,
  }) : super(key: key);

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  late Future<List<dynamic>> _cartAndProductsFuture;
  late List<CartItemEntity> localCartItems;
  late List<int> originalQuantities;
  final List<int> removedItemIds = [];

  // Group cart items by product
  final Map<int, List<CartItemEntity>> productToVariants = {};

  @override
  void initState() {
    super.initState();
    // Fetch the cart using either the initialCart or by ID.
    Future<CartEntity> cartFuture;
    if (widget.initialCart != null) {
      cartFuture = Future.value(widget.initialCart!);
    } else if (widget.cartId != null) {
      cartFuture =
          GetCartByIdUseCase(GetIt.I<CartRepository>())(widget.cartId!);
    } else {
      cartFuture = Future.error('No cartId provided');
    }

    // Fetch all products.
    final productsFuture = GetIt.I<GetAllProductsUseCase>()();
    // Combine both futures.
    _cartAndProductsFuture = Future.wait([cartFuture, productsFuture]);
  }

  void _initializeLocalLists(CartEntity cart) {
    localCartItems = (cart.items ?? []).map((i) => i.copyWith()).toList();
    originalQuantities = (cart.items ?? []).map((i) => i.quantity).toList();
  }

  /// Maps cart items to their parent products
  void _organizeByProduct(List<CartItemEntity> items, Map<int, Product> variantToProductMap) {
    productToVariants.clear();
    
    for (var item in items) {
      final variantId = item.productVariant.id;
      if (variantId != null) {
        final product = variantToProductMap[variantId];
        if (product != null && product.id != null) {
          final productId = product.id!;
          if (!productToVariants.containsKey(productId)) {
            productToVariants[productId] = [];
          }
          productToVariants[productId]!.add(item);
        }
      }
    }
  }

  void _increaseQuantity(CartItemEntity item) {
    setState(() {
      final index = localCartItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        localCartItems[index] = item.copyWith(quantity: item.quantity + 1);
        
        // Update in product groups too
        final variantId = item.productVariant.id;
        if (variantId != null) {
          for (var productId in productToVariants.keys) {
            final itemIndex = productToVariants[productId]!.indexWhere(
              (i) => i.id == item.id
            );
            if (itemIndex != -1) {
              productToVariants[productId]![itemIndex] = 
                  item.copyWith(quantity: item.quantity + 1);
              break;
            }
          }
        }
      }
    });
  }

  void _decreaseQuantity(CartItemEntity item) {
    setState(() {
      final index = localCartItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        if (item.quantity > 1) {
          final updatedItem = item.copyWith(quantity: item.quantity - 1);
          localCartItems[index] = updatedItem;
          
          // Update in product groups too
          for (var productId in productToVariants.keys) {
            final itemIndex = productToVariants[productId]!.indexWhere(
              (i) => i.id == item.id
            );
            if (itemIndex != -1) {
              productToVariants[productId]![itemIndex] = updatedItem;
              break;
            }
          }
        } else {
          // Remove the item entirely
          removedItemIds.add(item.id);
          localCartItems.removeAt(index);
          originalQuantities.removeAt(index);
          
          // Remove from product groups too
          for (var productId in productToVariants.keys) {
            productToVariants[productId]!.removeWhere((i) => i.id == item.id);
            if (productToVariants[productId]!.isEmpty) {
              productToVariants.remove(productId);
            }
          }
        }
      }
    });
  }

  void _saveChanges(CartEntity baseCart) {
    final bloc = context.read<CartBloc>();
    bool hasChange = false;

    for (var removedId in removedItemIds) {
      hasChange = true;
      bloc.add(RemoveItemFromCartEvent(baseCart.userId, removedId));
    }
    
    for (int i = 0; i < localCartItems.length; i++) {
      final m = localCartItems[i];
      final originalIndex = min(i, originalQuantities.length - 1);
      if (originalIndex >= 0 && m.quantity != originalQuantities[originalIndex]) {
        hasChange = true;
        bloc.add(UpdateCartItemEvent(baseCart.userId, m.id, m.quantity));
      }
    }

    if (!hasChange) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes detected')));
      return;
    }

    if (localCartItems.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, '/cart', (r) => false);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _createDeal(CartEntity cart) async {
  // Read the selected customer and cart details from secure storage.
  final selectedCustomerJson = await SecureStorageHelper.getSelectedCustomer();
  final selectedCartJson = await SecureStorageHelper.getSelectedCart();

  if (selectedCustomerJson == null || selectedCartJson == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Missing customer or cart details in storage')),
    );
    return;
  }

  // Get the logged-in user details.
  final userDataJson = await SecureStorageHelper.getUserData();
  if (userDataJson == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User data not found in storage')),
    );
    return;
  }

  // Convert the JSON maps to your domain entities.
  // Ensure that your CustomerEntity, CartEntity, and UserEntity have fromJson() methods
  final customerEntity = Customer.fromJson(selectedCustomerJson);
  final cartEntity = CartEntity.fromJson(selectedCartJson);
  final userEntity = User(
          id: 1,
          username: "salesman",
          email: "salesman@example.com");

  // Create a DealEntity.
  final deal = DealEntity(
    id: null, // New deal, so id is null (or handled accordingly)
    customerId: customerEntity,
    cartId: cartEntity,
    userId: userEntity,
    dealName: 'Deal for Cart ${cart.id}',
    dealStage: 'ADMIN_APPROVAL',
    amount: _calculateTotal(), // Ensure _calculateTotal() returns a double total from the cart
    quantity: localCartItems.length,
    deliveryAddress: 'Osmangunj', // Set a default or retrieve from elsewhere as needed
    expectedCloseDate: DateTime.now().add(const Duration(days: 7)),
    actualClosedDate: null,
    note: 'Deal created from CartDetailsPage',
  );

  // Call the CreateDealUseCase using GetIt.
  final createDealUseCase = GetIt.I<CreateDealUseCase>();
  try {
    final createdDeal = await createDealUseCase(deal);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deal created successfully')),
    );
    // Optionally navigate to the deal details page or perform other actions.
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating deal: $error')),
    );
  }
}
double _calculateTotal() =>
      localCartItems.fold(0, (sum, i) => sum + i.price * i.quantity);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;

    return FutureBuilder<List<dynamic>>(
      future: _cartAndProductsFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: primaryColor)));
        }
        if (snap.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snap.error}')));
        }

        // Expecting snapshot data as [CartEntity, List<Product>]
        final CartEntity cart = snap.data![0];
        final List<Product> products = snap.data![1];
        _initializeLocalLists(cart);

        // Build lookups for products and variants
        final Map<int, Product> variantIdToProduct = {};
        
        for (final product in products) {
          for (final variant in product.variants) {
            if (variant.id != null) {
              variantIdToProduct[variant.id!] = product;
            }
          }
        }

        return BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Cart Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cart #${cart.id}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(cart.status ?? '',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // Table Header - Visible only on larger screens
                  if (isLargeScreen && localCartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          const SizedBox(width: 70), // Image width
                          const SizedBox(width: 12),
                          const Expanded(
                            flex: 2,
                            child: Text('Product Details',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 60,
                            child: Text('Price', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 100,
                            child: Text('Quantity', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 80,
                            child: Text('Total', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right),
                          ),
                        ],
                      ),
                    ),
                  
                  Expanded(
                    child: localCartItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined, 
                                     size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text('Your cart is empty',
                                    style: TextStyle(
                                        fontSize: 18, 
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54)),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                      context, '/products', (r) => false),
                                  child: const Text('Browse Products',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                        : isLargeScreen
                            // Large Screen Table View
                            ? _buildTableView(localCartItems, variantIdToProduct)
                            // Mobile Screen Card View
                            : _buildCardView(localCartItems, variantIdToProduct, isSmallScreen),
                  ),
                  
                  // Total and Action Buttons (Save Changes and Create Deal)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          // Total row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:',
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold
                                  )),
                              Text('\$${_calculateTotal().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Action Buttons row
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => _saveChanges(cart),
                                    child: const Text('Add Remainder',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => _createDeal(cart),
                                    child: const Text('Create Deal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableView(List<CartItemEntity> items, Map<int, Product> variantIdToProduct) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final variant = item.productVariant;
        final product = variantIdToProduct[variant.id];
        
        if (product == null) return const SizedBox.shrink();
        
        final hasImage = variant.imageUrls.isNotEmpty;
        final variantImage = hasImage ? variant.imageUrls.first.imageUrl : null;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: variantImage != null
                    ? Image.network(
                        variantImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              
              // Product & Variant Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/product/${product.id}',
                      ),
                      child: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      variant.variantName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (variant.sku.isNotEmpty)
                      Text(
                        'SKU: ${variant.sku}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Price
              SizedBox(
                width: 60,
                child: Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              
              // Quantity
              SizedBox(
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _decreaseQuantity(item),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(7),
                              bottomLeft: Radius.circular(7),
                            ),
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 36),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () => _increaseQuantity(item),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Total
              SizedBox(
                width: 80,
                child: Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardView(List<CartItemEntity> items, Map<int, Product> variantIdToProduct, bool isSmallScreen) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final variant = item.productVariant;
        final product = variantIdToProduct[variant.id];
        
        if (product == null) return const SizedBox.shrink();
        
        final hasImage = variant.imageUrls.isNotEmpty;
        final variantImage = hasImage ? variant.imageUrls.first.imageUrl : null;
        // Check whether this product qualifies (for example, if its name contains "shoe")
        final isShoeProduct = product.productName.toLowerCase().contains("shoe");
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header row with image and product name (with variant details)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap the product image in a Stack to overlay a badge if it qualifies.
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: variantImage != null
                              ? Image.network(
                                  variantImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        // Display "Variant Boss" badge if this is a shoe product.
                        if (isShoeProduct)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Variant Boss',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    
                    // Product & Variant Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/product/${product.id}',
                            ),
                            child: Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            variant.variantName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (variant.sku.isNotEmpty)
                            Text(
                              'SKU: ${variant.sku}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Details in table-like rows (Price, Quantity controls, Subtotal)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Price row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      
                      // Quantity row with controls
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => _decreaseQuantity(item),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(minWidth: 36),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                          fontSize: 15, 
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _increaseQuantity(item),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      
                      // Subtotal row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFE41B47),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
