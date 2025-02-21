// lib/features/customer/presentation/pages/customer_detail_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';

// Domain and Use Case imports
import '../../domain/entities/customer_entity.dart';
import '../../domain/usecases/get_customer_by_id.dart';
import '../../domain/usecases/update_customer.dart';

// Data Layer imports
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';

// Define your primary color constant.
const primaryColor = Color(0xFFE41B47);

class CustomerDetailPage extends StatefulWidget {
  final String baseUrl;

  const CustomerDetailPage({super.key, required this.baseUrl});

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  bool _isLoading = true;
  bool _isEditing = false;
  Customer? _customer;

  // Form controllers for updating customer details.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ordersController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  late final http.Client client;
  late final ApiClient apiClient;
  late final CustomerRemoteDataSourceImpl remoteDataSource;
  late final CustomerRepositoryImpl repository;
  late final GetCustomerById getCustomerByIdUseCase;
  late final UpdateCustomer updateCustomerUseCase;

  int? customerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve customer ID from navigation arguments.
    if (_isLoading) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) {
        customerId = args;
        client = http.Client();
        apiClient = ApiClient(widget.baseUrl, client);
        remoteDataSource = CustomerRemoteDataSourceImpl(apiClient: apiClient);
        repository = CustomerRepositoryImpl(remoteDataSource: remoteDataSource);
        getCustomerByIdUseCase = GetCustomerById(repository);
        updateCustomerUseCase = UpdateCustomer(repository);
        _fetchCustomer();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid or missing customer ID")),
        );
      }
    }
  }

  Future<void> _fetchCustomer() async {
    try {
      final fetchedCustomer = await getCustomerByIdUseCase.call(customerId!);
      setState(() {
        _customer = fetchedCustomer;
        _initializeControllers(fetchedCustomer);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching customer: $e")),
      );
    }
  }

  void _initializeControllers(Customer customer) {
    _nameController.text = customer.customerName;
    _emailController.text = customer.email;
    _phoneController.text = customer.phoneNumber;
    _addressController.text = customer.address;
    _ordersController.text = customer.noOfOrders.toString();
    _companyController.text = customer.buyerCompanyName;
  }

  Future<void> _saveUpdates() async {
    if (customerId == null || _customer == null) return;

    final updatedCustomer = Customer(
      id: _customer!.id,
      customerName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      noOfOrders: int.tryParse(_ordersController.text) ?? _customer!.noOfOrders,
      buyerCompanyName: _companyController.text,
    );

    try {
      final result =
          await updateCustomerUseCase.call(customerId!, updatedCustomer);
      setState(() {
        _customer = result;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update customer: $e")),
      );
    }
  }

  Widget _buildHeader() {
    // Header with a gradient background using primaryColor and a slightly lighter variant.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              _customer!.customerName.isNotEmpty
                  ? _customer!.customerName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 32,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _customer!.customerName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _customer!.email,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard() {
    // Card that displays customer details in a modern design.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow(Icons.phone, "Phone", _customer!.phoneNumber),
            const Divider(),
            _buildDetailRow(Icons.location_on, "Address", _customer!.address),
            const Divider(),
            _buildDetailRow(
                Icons.list_alt, "Orders", _customer!.noOfOrders.toString()),
            const Divider(),
            _buildDetailRow(
                Icons.business, "Buyer Company", _customer!.buyerCompanyName),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 16),
        Text(
          "$label: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildViewMode() {
    return Column(
      children: [
        _buildHeader(),
        _buildDetailCard(),
      ],
    );
  }

  Widget _buildEditMode() {
    // Editable form fields in a scrollable view.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Editable fields use outlined input fields.
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Customer Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: "Address",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ordersController,
            decoration: const InputDecoration(
              labelText: "Number of Orders",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: "Buyer Company Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveUpdates,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Save Updates"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Detail",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isEditing
              ? _buildEditMode()
              : SingleChildScrollView(child: _buildViewMode()),
    );
  }
}
