import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/domain/usecases/get_all_customers.dart';
import 'package:pura_crm/features/customer/domain/usecases/create_customer.dart';
import 'package:pura_crm/features/customer/domain/usecases/get_customer_by_id.dart';

class DealCustomerCreatePage extends StatefulWidget {
  const DealCustomerCreatePage({super.key});

  @override
  _DealCustomerCreatePageState createState() => _DealCustomerCreatePageState();
}

class _DealCustomerCreatePageState extends State<DealCustomerCreatePage> {
  bool _showForm = false;
  Customer? _selectedCustomer;
  List<Customer> _customers = [];

  // Form key and controllers for new customer form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ordersController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  // Primary color.
  final Color primaryColor = const Color(0xFFE41B47);

  // Instantiate use cases via dependency injection.
  final GetAllCustomers getAllCustomersUseCase =
      GetAllCustomers(GetIt.instance());
  final CreateCustomer createCustomerUseCase = CreateCustomer(GetIt.instance());
  final GetCustomerById getCustomerByIdUseCase =
      GetCustomerById(GetIt.instance());

  @override
  void initState() {
    super.initState();
    _ordersController.text = '0'; // Set initial value on the controller.
    _fetchCustomers();
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

  // Fetch customer details.
  Future<void> _fetchCustomers() async {
    try {
      final fetchedCustomers = await getAllCustomersUseCase.call();
      setState(() {
        _customers = fetchedCustomers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch customers')),
      );
    }
  }

  // Toggle form visibility.
  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  // Save and continue.
  Future<void> _saveAndContinue() async {
    Customer? customerToUse;
    if (_showForm) {
      if (_formKey.currentState!.validate()) {
        final newCustomer = Customer(
          id: 0, // Backend assigns ID.
          customerName: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          noOfOrders: 0,
          buyerCompanyName: _companyController.text,
        );
        try {
          final createdCustomer = await createCustomerUseCase.call(newCustomer);
          setState(() {
            _customers.add(createdCustomer);
            _selectedCustomer = createdCustomer;
            _showForm = false;
            // Clear form fields.
            _nameController.clear();
            _emailController.clear();
            _phoneController.clear();
            _addressController.clear();
            _ordersController.text = '0';
            _companyController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer created successfully')),
          );
          customerToUse = createdCustomer;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create customer')),
          );
          return;
        }
      } else {
        return;
      }
    } else {
      if (_selectedCustomer != null) {
        customerToUse = _selectedCustomer;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No customer selected')),
        );
        return;
      }
    }
    if (customerToUse != null) {
      Navigator.pushNamed(
        context,
        '/deal/product/add',
        arguments: customerToUse,
      );
    }
  }

  // Build input decorations.
  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

  // Build customer details widget.
  Widget _buildCustomerDetails(Customer customer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: primaryColor),
            title: Text(
              customer.customerName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.email, color: primaryColor),
            title: Text(customer.email),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: primaryColor),
            title: Text(customer.phoneNumber),
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: primaryColor),
            title: Text(customer.address),
          ),
          ListTile(
            leading: Icon(Icons.business, color: primaryColor),
            title: Text(customer.buyerCompanyName),
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered, color: primaryColor),
            title: Text('No. of Orders: ${customer.noOfOrders}'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Select or Create Customer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Dropdown widget.
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<Customer>(
                        isExpanded: true,
                        value: _selectedCustomer,
                        hint: const Text('Select a customer'),
                        underline: Container(),
                        onChanged: (Customer? newValue) {
                          setState(() {
                            _selectedCustomer = newValue;
                            _showForm = false;
                          });
                        },
                        items: _customers.map((Customer customer) {
                          return DropdownMenuItem<Customer>(
                            value: customer,
                            child: Text(customer.customerName),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline,
                          color: primaryColor, size: 30),
                      onPressed: _toggleForm,
                    ),
                  ],
                ),
              ),
            ),
            // Expanded scrollable area.
            Expanded(
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showForm
                      ? Card(
                          key: const ValueKey('createForm'),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    'Create New Customer',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: _buildInputDecoration(
                                      label: 'Customer Name',
                                      icon: Icons.person,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter customer name'
                                            : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: _buildInputDecoration(
                                      label: 'Email',
                                      icon: Icons.email,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter email'
                                            : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: _buildInputDecoration(
                                      label: 'Phone Number',
                                      icon: Icons.phone,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter phone number'
                                            : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _addressController,
                                    decoration: _buildInputDecoration(
                                      label: 'Address',
                                      icon: Icons.location_on,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter address'
                                            : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _ordersController,
                                    decoration: _buildInputDecoration(
                                      label: 'Number of Orders',
                                      icon: Icons.format_list_numbered,
                                    ),
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _companyController,
                                    decoration: _buildInputDecoration(
                                      label: 'Buyer Company Name',
                                      icon: Icons.business,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Please enter buyer company name'
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : _selectedCustomer != null
                          ? _buildCustomerDetails(_selectedCustomer!)
                          : const SizedBox(key: ValueKey('empty')),
                ),
              ),
            ),
            // Save and Continue button.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _saveAndContinue,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Save and Continue',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
