import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/features/auth/domain/entities/salesman.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';

class SalesmanCreatePage extends StatefulWidget {
  @override
  _SalesmanCreatePageState createState() => _SalesmanCreatePageState();
}

class _SalesmanCreatePageState extends State<SalesmanCreatePage> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regionAssignedController = TextEditingController();
  final TextEditingController _totalSalesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _dateOfBirth;
  DateTime _hireDate = DateTime.now();
  String _status = 'ACTIVE';
  final List<String> _statusOptions = ['ACTIVE', 'JOINING', 'DEACTIVATED'];

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final DateTime initialDate = isBirthDate ? DateTime.now().subtract(Duration(days: 365 * 18)) : DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _dateOfBirth = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Salesman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // TextFormField(
                //   controller: _nameController,
                //   decoration: InputDecoration(
                //     prefixIcon: const Icon(Icons.person, color: Color(0xFFE41B47)),
                //     labelText: 'Name',
                //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //     focusedBorder: const OutlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFFE41B47)),
                //     ),
                //   ),
                //   validator: (value) => value == null || value.isEmpty ? 'Please enter the name' : null,
                // ),
                // const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Color(0xFFE41B47)),
                    labelText: 'Phone',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the phone number' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on, color: Color(0xFFE41B47)),
                    labelText: 'Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the address' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _regionAssignedController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.map, color: Color(0xFFE41B47)),
                    labelText: 'Region Assigned',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the region assigned' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalSalesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.bar_chart, color: Color(0xFFE41B47)),
                    labelText: 'Total Sales',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the total sales' : null,
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.flag, color: Color(0xFFE41B47)),
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  validator: (value) => value == null ? 'Please select a status' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.note, color: Color(0xFFE41B47)),
                    labelText: 'Notes',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE41B47)),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Date of Birth:'),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        _dateOfBirth == null
                            ? 'Select Date'
                            : _dateOfBirth!.toLocal().toString().split(' ')[0],
                        style: const TextStyle(color: Color(0xFFE41B47)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newSalesman = Salesman(
                        phoneNumber: _phoneController.text,
                        address: _addressController.text,
                        dateOfBirth: _dateOfBirth ?? DateTime.now(),
                        regionAssigned: _regionAssignedController.text,
                        totalSales: double.tryParse(_totalSalesController.text) ?? 0.0,
                        hireDate: _hireDate,
                        status: _status,
                        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                      );

                      try {
                        // Assuming createSalesmanDetails returns a Future<bool>
                        final isSuccess = await Provider.of<SalesmanProvider>(context, listen: false)
                            .createSalesmanDetails(newSalesman);

                        if (isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Salesman created successfully')),
                          );
                          Navigator.pop(context); // Navigate back after success
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to create Salesman. Please try again.')),
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${error.toString()}')),
                        );
                      }
                    }
                  },
                  child: const Text('Create Salesman'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
