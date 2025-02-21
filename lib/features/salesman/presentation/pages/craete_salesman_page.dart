import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';
import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

class SalesmanCreatePage extends StatefulWidget {
  const SalesmanCreatePage({super.key});

  @override
  _SalesmanCreatePageState createState() => _SalesmanCreatePageState();
}

class _SalesmanCreatePageState extends State<SalesmanCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regionAssignedController =
      TextEditingController();
  final TextEditingController _totalSalesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _dateOfBirth;
  final DateTime _hireDate = DateTime.now();
  String _status = 'ACTIVE';
  final List<String> _statusOptions = ['ACTIVE', 'JOINING', 'DEACTIVATED'];

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE41B47), Color(0xFFF78DA7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    // Page title
                    const Text(
                      'Create Salesman',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Form container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the phone number'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Icons.location_on,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the address'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _regionAssignedController,
                              decoration: const InputDecoration(
                                labelText: 'Region Assigned',
                                prefixIcon: Icon(Icons.map,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the region assigned'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _totalSalesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Total Sales',
                                prefixIcon: Icon(Icons.bar_chart,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the total sales'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _status,
                              items: _statusOptions
                                  .map((status) => DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _status = value!;
                              }),
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.flag,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null
                                  ? 'Please select a status'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Notes',
                                prefixIcon: Icon(Icons.note,
                                    color: Colors.red), // Red color
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Date of Birth:'),
                                TextButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    _dateOfBirth == null
                                        ? 'Select Date'
                                        : _dateOfBirth!
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                    style: const TextStyle(
                                        color: Color(0xFFE41B47)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final newSalesman = Salesman(
                                    phoneNumber: _phoneController.text,
                                    address: _addressController.text,
                                    dateOfBirth: _dateOfBirth ?? DateTime.now(),
                                    regionAssigned:
                                        _regionAssignedController.text,
                                    totalSales: double.tryParse(
                                            _totalSalesController.text) ??
                                        0.0,
                                    hireDate: _hireDate,
                                    status: _status,
                                    notes: _notesController.text.isNotEmpty
                                        ? _notesController.text
                                        : null,
                                  );

                                  try {
                                    final bool isSuccess =
                                        await Provider.of<SalesmanProvider>(
                                                context,
                                                listen: false)
                                            .createSalesmanDetails(newSalesman);

                                    if (isSuccess) {
                                      SnackBarUtils.showSuccessSnackBar(
                                        context,
                                        'Salesman created successfully',
                                      );
                                      Navigator.pop(
                                          context); // Navigate back to the previous screen
                                    } else {
                                      SnackBarUtils.showErrorSnackBar(
                                        context,
                                        'Failed to create Salesman. Please try again.',
                                      );
                                    }
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error: ${error.toString()}')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE41B47),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Create Salesman'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
