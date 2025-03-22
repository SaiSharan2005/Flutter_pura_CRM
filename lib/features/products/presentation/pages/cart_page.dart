import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/products/presentation/pages/cart_detail.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';
import 'package:pura_crm/utils/dynamic_navbar.dart'; // Ensure MainLayout is imported

class UserCartsPage extends StatefulWidget {
  const UserCartsPage({super.key});

  @override
  State<UserCartsPage> createState() => _UserCartsPageState();
}

class _UserCartsPageState extends State<UserCartsPage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchCarts();
  }

  Future<void> _loadUserAndFetchCarts() async {
    final user = await SecureStorageHelper.getUserData();
    if (!mounted) return;
    if (user != null) {
      setState(() {
        userId = user.id;
      });
      debugPrint('Loaded user id: ${user.id}');
      context.read<DemoCartBloc>().add(GetCartsByUserIdEvent(user.id));
    } else {
      debugPrint('No user data found.');
      // Optionally, handle the case when user data is missing (e.g., navigate to login)
    }
  }

  void _refreshCarts() {
    if (userId != null) {
      context.read<DemoCartBloc>().add(GetCartsByUserIdEvent(userId!));
    }
  }

  void _deleteCart(int cartId) {
    if (userId != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Cart'),
          content: const Text('Are you sure you want to delete this cart?'),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('Delete cancelled for cart: $cartId');
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                debugPrint(
                    'Dispatching RemoveCartEvent for cartId: $cartId, userId: $userId');
                Navigator.pop(context);
                context.read<DemoCartBloc>().add(
                      RemoveCartEvent(cartId: cartId, userId: userId!),
                    );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  void _createCart() {
    if (userId != null) {
      context.read<DemoCartBloc>().add(CreateCartEvent(userId!));
      // Refresh the carts after a brief delay.
      Future.delayed(const Duration(seconds: 1), () {
        context.read<DemoCartBloc>().add(GetCartsByUserIdEvent(userId!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Your Carts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCarts,
          ),
        ],
      ),
      body: SafeArea(
        child: userId == null
            ? const Center(child: CircularProgressIndicator())
            : BlocBuilder<DemoCartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartsLoadSuccess) {
                    debugPrint("CartsLoadSuccess: ${state.carts}");
                    final carts = state.carts;
                    if (carts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No carts found for this user.',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _refreshCarts(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: carts.length,
                        itemBuilder: (context, index) {
                          final cart = carts[index];
                          final itemCount = cart.items?.length ?? 0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: '/cart/detail'),
                                    builder: (_) => MainLayout(
                                      child: CartDetailsPage(cart: cart),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: screenWidth * 0.18,
                                        height: screenWidth * 0.18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Cart #${cart.id}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '$itemCount item${itemCount != 1 ? 's' : ''}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Chip(
                                                backgroundColor:
                                                    Colors.blue.shade100,
                                                label: Text(
                                                  cart.status,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                          onPressed: () => _deleteCart(cart.id),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CartError) {
                    debugPrint("CartError: ${state.message}");
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else {
                    debugPrint("No data found in state: $state");
                    return const Center(
                      child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createCart,
        backgroundColor: primaryColor,
        elevation: 6.0,
        icon: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
        label: const Text(
          'New Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
