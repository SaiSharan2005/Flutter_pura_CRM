import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class UserCartsPage extends StatefulWidget {
  const UserCartsPage({Key? key}) : super(key: key);

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

  void _loadUserAndFetchCarts() async {
    final user = await SecureStorageHelper.getUserData();
    if (user != null) {
      setState(() {
        userId = user.id;
      });
      context.read<CartBloc>().add(GetCartsByUserIdEvent(user.id));
    }
  }

  void _refreshCarts() {
    if (userId != null) {
      context.read<CartBloc>().add(GetCartsByUserIdEvent(userId!));
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<CartBloc>().add(RemoveCartEvent(cartId));
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  void _createCart() {
    if (userId != null) {
      context.read<CartBloc>().add(CreateCartEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Carts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCarts,
          ),
        ],
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CartListSuccess) {
                  final carts = state.carts;
                  if (carts.isEmpty) {
                    return const Center(
                        child: Text('No carts found for this user.'));
                  }
                  return ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text('Cart ID: ${cart.id}'),
                          subtitle: Text('Status: ${cart.status}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCart(cart.id),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CartError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createCart,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
        backgroundColor: const Color(0xFFE41B47),
        elevation: 6.0,
      ),
    );
  }
}
