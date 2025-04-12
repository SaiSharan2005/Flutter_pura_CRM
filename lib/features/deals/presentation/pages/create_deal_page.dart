// lib/features/deals/presentation/pages/deal_create_page.dart

import 'package:flutter/material.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/domain/usecases/get_all_customers.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/usecases/create_deal_usecase.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';

const primaryColor = Color(0xFFE41B47);

class DealCreatePage extends StatefulWidget {
  final int userId; // Current user's (salesman's) id
  final GetAllCustomers getAllCustomersUseCase;
  final GetCartsByUserIdUseCase getCartsByUserIdUseCase;
  final CreateDealUseCase createDealUseCase;

  const DealCreatePage({
    super.key,
    required this.userId,
    required this.getAllCustomersUseCase,
    required this.getCartsByUserIdUseCase,
    required this.createDealUseCase,
  });

  @override
  _DealCreatePageState createState() => _DealCreatePageState();
}

class _DealCreatePageState extends State<DealCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for deal fields.
  final TextEditingController _dealNameController = TextEditingController();
  final TextEditingController _dealStageController = TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _expectedCloseDateController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  // Dropdown lists.
  List<Customer> _customers = [];
  List<CartEntity> _carts = [];

  // Selected items.
  Customer? selectedCustomer;
  CartEntity? selectedCart;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final customers = await widget.getAllCustomersUseCase.call();
      final carts = await widget.getCartsByUserIdUseCase.call(widget.userId);
      setState(() {
        _customers = customers;
        _carts = carts;
        if (_customers.isNotEmpty) selectedCustomer = _customers.first;
        if (_carts.isNotEmpty) selectedCart = _carts.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  /// Helper function to calculate the total amount from the selected cart.
  double _calculateTotalSum(CartEntity cart) {
    double sum = 0;
    // Assuming CartEntity has a list field named `items`
    // and each item has nullable fields: price (double?) and quantity (int?).
    for (var item in cart.items) {
      double price = item.price ?? 0.0;
      int quantity = item.quantity ?? 0;
      sum += price * quantity;
    }
    return sum;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCustomer == null || selectedCart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a customer and a cart")),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
    });

    // Calculate the total amount from the selected cart.
    final double amount = _calculateTotalSum(selectedCart!);

    // Create a new DealEntity.
    final newDeal = DealEntity(
      customerId: selectedCustomer!,
      cartId: selectedCart!,
      userId: User(id: widget.userId, username: "", email: ""),
      dealName: _dealNameController.text,
      dealStage: _dealStageController.text,
      amount: amount,
      quantity: 1, // Fixed to 1.
      deliveryAddress: _deliveryAddressController.text,
      expectedCloseDate: DateTime.tryParse(_expectedCloseDateController.text) ??
          DateTime.now(),
      actualClosedDate: null, // Kept as null.
      note: _noteController.text,
    );

    try {
      await widget.createDealUseCase.call(newDeal);
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deal created successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create deal: $e")),
      );
    }
  }

  @override
  void dispose() {
    _dealNameController.dispose();
    _dealStageController.dispose();
    _deliveryAddressController.dispose();
    _expectedCloseDateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Deal", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _customers.isEmpty || _carts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dropdown for selecting customer.
                    DropdownButtonFormField<Customer>(
                      value: selectedCustomer,
                      decoration: const InputDecoration(
                        labelText: "Select Customer",
                        border: OutlineInputBorder(),
                      ),
                      items: _customers.map((customer) {
                        return DropdownMenuItem<Customer>(
                          value: customer,
                          child: Text(customer.customerName),
                        );
                      }).toList(),
                      onChanged: (Customer? newValue) {
                        setState(() {
                          selectedCustomer = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a customer" : null,
                    ),
                    const SizedBox(height: 16),
                    // Dropdown for selecting cart.
                    DropdownButtonFormField<CartEntity>(
                      value: selectedCart,
                      decoration: const InputDecoration(
                        labelText: "Select Cart",
                        border: OutlineInputBorder(),
                      ),
                      items: _carts.map((cart) {
                        return DropdownMenuItem<CartEntity>(
                          value: cart,
                          child: Text("Cart #${cart.id}"),
                        );
                      }).toList(),
                      onChanged: (CartEntity? newValue) {
                        setState(() {
                          selectedCart = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a cart" : null,
                    ),
                    const SizedBox(height: 16),
                    // Deal Name Field
                    TextFormField(
                      controller: _dealNameController,
                      decoration: const InputDecoration(
                        labelText: "Deal Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter deal name"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Deal Stage Field
                    TextFormField(
                      controller: _dealStageController,
                      decoration: const InputDecoration(
                        labelText: "Deal Stage",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter deal stage"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Delivery Address Field
                    TextFormField(
                      controller: _deliveryAddressController,
                      decoration: const InputDecoration(
                        labelText: "Delivery Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter delivery address"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Expected Close Date Field
                    TextFormField(
                      controller: _expectedCloseDateController,
                      decoration: const InputDecoration(
                        labelText: "Expected Close Date (YYYY-MM-DD)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Enter expected close date"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Note Field
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: "Note",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.check),
                            label: const Text("Create Deal"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
