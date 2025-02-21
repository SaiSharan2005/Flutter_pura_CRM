// lib/features/customer/presentation/pages/create_customer_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';

// Domain and Use Case imports
import '../../domain/entities/customer_entity.dart';
import '../../domain/usecases/create_customer.dart';
// Data Layer imports
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';

// Define your primary color.
const primaryColor = Color(0xFFE41B47);

class CreateCustomerPage extends StatefulWidget {
  final String baseUrl;

  const CreateCustomerPage({super.key, required this.baseUrl});

  @override
  _CreateCustomerPageState createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ordersController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Create a new Customer instance.
    // Note: The id is set to 0 because the backend is expected to generate the actual ID.
    final newCustomer = Customer(
      id: 0,
      customerName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      noOfOrders: int.tryParse(_ordersController.text) ?? 0,
      buyerCompanyName: _companyController.text,
    );

    // Initialize dependencies using your ApiClient.
    final client = http.Client();
    final apiClient = ApiClient(widget.baseUrl, client);
    final remoteDataSource = CustomerRemoteDataSourceImpl(apiClient: apiClient);
    final repository =
        CustomerRepositoryImpl(remoteDataSource: remoteDataSource);
    final createCustomerUseCase = CreateCustomer(repository);

    try {
      await createCustomerUseCase.call(newCustomer);
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer created successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create customer")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ordersController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Customer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "New Customer",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: primaryColor),
                  ),
                  const SizedBox(height: 20),
                  // Customer Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter customer name"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter email"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Phone Number Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter phone number"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Address Field
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter address"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Number of Orders Field
                  TextFormField(
                    controller: _ordersController,
                    decoration: const InputDecoration(
                      labelText: "Number of Orders",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter number of orders"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Buyer Company Name Field
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: "Buyer Company Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please enter buyer company name"
                        : null,
                  ),
                  const SizedBox(height: 24),
                  _isSubmitting
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.check),
                          label: const Text("Create Customer"),
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
        ),
      ),
    );
  }
}
