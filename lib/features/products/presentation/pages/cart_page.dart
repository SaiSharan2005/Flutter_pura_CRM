// lib/features/products/presentation/pages/user_carts_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

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
      setState(() => userId = user.id);
      context.read<CartBloc>().add(GetCartsByUserIdEvent(user.id));
    }
  }

  void _refreshCarts() {
    if (userId != null) {
      context.read<CartBloc>().add(GetCartsByUserIdEvent(userId!));
    }
  }

  void _deleteCart(int cartId) {
    if (userId == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Cart'),
        content: const Text('Are you sure you want to delete this cart?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartBloc>().add(RemoveCartEvent(cartId: cartId, userId: userId!));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _createCart() async {
    if (userId == null) return;
    context.read<CartBloc>().add(CreateCartEvent(userId!));
    // refresh when operation succeeds (in BlocListener/Consumer)
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Your Carts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshCarts)],
      ),
      body: SafeArea(
        child: userId == null
            ? const Center(child: CircularProgressIndicator())
            : BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartOperationSuccess) _refreshCarts();
                  if (state is CartError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CartsLoadSuccess) {
                    final carts = state.carts;
                    if (carts.isEmpty) {
                      return const Center(child: Text('No carts found.', style: TextStyle(fontSize: 18)));
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _refreshCarts(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: carts.length,
                        itemBuilder: (context, i) {
                          final cart = carts[i];
                          final itemCount = cart.items?.length ?? 0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                // Named route with cartId
                                Navigator.pushNamed(context, '/cart/detail/${cart.id}');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Cart #${cart.id}',
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '$itemCount item${itemCount != 1 ? 's' : ''}',
                                                  style: const TextStyle(
                                                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Chip(
                                                backgroundColor: Colors.blue.shade100,
                                                label: Text(cart.status,
                                                    style: const TextStyle(
                                                        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                                          onPressed: () => _deleteCart(cart.id),
                                        ),
                                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
                  }
                  return Center(child: Text(state is CartError ? 'Error: ${state.message}' : 'No data.'));
                },
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton.extended(
          onPressed: _createCart,
          backgroundColor: primaryColor,
          elevation: 6,
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text('New Cart', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
