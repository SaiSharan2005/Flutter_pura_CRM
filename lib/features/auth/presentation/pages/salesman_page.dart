import 'package:flutter/material.dart';
import 'package:pura_crm/features/auth/domain/entities/salesman.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';

class SalesmanCreatePage extends StatefulWidget {
  @override
  _SalesmanCreatePageState createState() => _SalesmanCreatePageState();
}

class _SalesmanCreatePageState extends State<SalesmanCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regionAssignedController = TextEditingController();
  final TextEditingController _totalSalesController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _dateOfBirth;
  DateTime? _hireDate;

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
        } else {
          _hireDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Salesman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _regionAssignedController,
                  decoration: InputDecoration(labelText: 'Region Assigned'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the region assigned';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalSalesController,
                  decoration: InputDecoration(labelText: 'Total Sales'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the total sales';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the status';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date of Birth:'),
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                        _dateOfBirth == null
                            ? 'Select Date'
                            : _dateOfBirth!.toLocal().toString().split(' ')[0],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hire Date:'),
                    TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text(
                        _hireDate == null
                            ? 'Select Date'
                            : _hireDate!.toLocal().toString().split(' ')[0],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newSalesman = Salesman(
                        phoneNumber: _phoneController.text,
                        address: _addressController.text,
                        dateOfBirth: _dateOfBirth!,
                        regionAssigned: _regionAssignedController.text,
                        totalSales: double.tryParse(_totalSalesController.text) ?? 0.0,
                        hireDate: _hireDate!,
                        status: _statusController.text,
                        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                      );

                      // Call the SalesmanProvider to create the salesman
                      Provider.of<SalesmanProvider>(context, listen: false)
                          .createSalesmanDetails(newSalesman);

                      // Optionally, show a success message and navigate back
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Salesman created successfully')),
                      );
                      Navigator.pop(context); // Go back to previous page
                    }
                  },
                  child: Text('Create Salesman'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
