import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';

class SecureStorageDisplayPage extends StatefulWidget {
  const SecureStorageDisplayPage({Key? key}) : super(key: key);

  @override
  _SecureStorageDisplayPageState createState() => _SecureStorageDisplayPageState();
}

class _SecureStorageDisplayPageState extends State<SecureStorageDisplayPage> {
  String? _token;
  UserDTO? _user;
  Map<String, dynamic>? _selectedCustomer;
  Map<String, dynamic>? _selectedCart;

  // Controllers for update functionality.
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _cartController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    // Retrieve data from secure storage.
    final token = await SecureStorageHelper.getToken();
    final user = await SecureStorageHelper.getUserData();
    final customer = await SecureStorageHelper.getSelectedCustomer();
    final cart = await SecureStorageHelper.getSelectedCart();

    setState(() {
      _token = token;
      _user = user;
      _selectedCustomer = customer;
      _selectedCart = cart;

      // Set initial text values for the controllers.
      _tokenController.text = token ?? '';
      _userController.text = user != null ? jsonEncode(user.toJson()) : '';
      _customerController.text = customer != null ? jsonEncode(customer) : '';
      _cartController.text = cart != null ? jsonEncode(cart) : '';
    });
  }

  // Update token method
  Future<void> _updateToken() async {
    final newToken = _tokenController.text;
    await SecureStorageHelper.saveToken(newToken);
    _loadAllData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token updated')),
    );
  }

  // Update user data method
  Future<void> _updateUserData() async {
    try {
      final userMap = jsonDecode(_userController.text);
      final user = UserDTO.fromJson(userMap);
      await SecureStorageHelper.saveUserData(user);
      _loadAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid user data: $e')),
      );
    }
  }

  // Update selected customer method
  Future<void> _updateSelectedCustomer() async {
    try {
      final customerMap = jsonDecode(_customerController.text);
      await SecureStorageHelper.saveSelectedCustomer(customerMap);
      _loadAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected customer updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid customer data: $e')),
      );
    }
  }

  // Update selected cart method
  Future<void> _updateSelectedCart() async {
    try {
      final cartMap = jsonDecode(_cartController.text);
      await SecureStorageHelper.saveSelectedCart(cartMap);
      _loadAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected cart updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid cart data: $e')),
      );
    }
  }

  // Helper widget to build each data section with an update option.
  Widget _buildDataSection({
    required String label,
    required TextEditingController controller,
    required VoidCallback onUpdate,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                hintText: 'Enter new value for $label',
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onUpdate,
                child: const Text('Update'),
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
        title: const Text('Stored Secure Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDataSection(
              label: 'JWT Token',
              controller: _tokenController,
              onUpdate: _updateToken,
            ),
            _buildDataSection(
              label: 'User Data (JSON)',
              controller: _userController,
              onUpdate: _updateUserData,
            ),
            _buildDataSection(
              label: 'Selected Customer (JSON)',
              controller: _customerController,
              onUpdate: _updateSelectedCustomer,
            ),
            _buildDataSection(
              label: 'Selected Cart (JSON)',
              controller: _cartController,
              onUpdate: _updateSelectedCart,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadAllData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
