import 'package:flutter/material.dart';
import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';
import 'package:pura_crm/features/auth/domain/usecases/logistic_person_usecase.dart';
// import 'package:pura_crm/features/auth/domain/entities/logistic_person_entity.dart';
// import 'package:pura_crm/features/auth/domain/usecases/logistic_person_use_case.dart';
// import 'package:pura_crm/features/auth/domain/repositories/logistic_person_repository.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

class LogisticPersonCreatePage extends StatefulWidget {
  final LogisticPersonRepository repository;

  LogisticPersonCreatePage({required this.repository});

  @override
  _LogisticPersonCreatePageState createState() =>
      _LogisticPersonCreatePageState();
}

class _LogisticPersonCreatePageState extends State<LogisticPersonCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _deliveryAreasController =
      TextEditingController();
  final TextEditingController _vehicleInfoController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _dateOfBirth;

  late final CreateLogisticPersonUseCase createLogisticPersonUseCase;

  @override
  void initState() {
    super.initState();
    createLogisticPersonUseCase =
        CreateLogisticPersonUseCase(widget.repository);
  }

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
                      'Create Logistic Person',
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
                                labelText: 'Phone Number',
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.red),
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
                                prefixIcon:
                                    Icon(Icons.location_on, color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the address'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _deliveryAreasController,
                              decoration: const InputDecoration(
                                labelText: 'Delivery Areas',
                                prefixIcon: Icon(Icons.map, color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the delivery areas'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _vehicleInfoController,
                              decoration: const InputDecoration(
                                labelText: 'Vehicle Info',
                                prefixIcon: Icon(Icons.directions_car,
                                    color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the vehicle info'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _licenseNumberController,
                              decoration: const InputDecoration(
                                labelText: 'License Number',
                                prefixIcon: Icon(Icons.card_membership,
                                    color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter the license number'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _statusController.text.isNotEmpty
                                  ? _statusController.text
                                  : null,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.flag, color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'Active',
                                  child: Text('Active'),
                                ),
                                DropdownMenuItem(
                                  value: 'Inactive',
                                  child: Text('Inactive'),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _statusController.text = newValue ?? '';
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please select a status'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Notes',
                                prefixIcon: Icon(Icons.note, color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please add some notes'
                                      : null,
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
                                  final newLogisticPerson =
                                      LogisticPersonEntity(
                                    phoneNumber: _phoneController.text,
                                    address: _addressController.text,
                                    dateOfBirth: _dateOfBirth ?? DateTime.now(),
                                    deliveryAreas:
                                        _deliveryAreasController.text,
                                    vehicleInfo: _vehicleInfoController.text,
                                    licenseNumber:
                                        _licenseNumberController.text,
                                    status: _statusController.text,
                                    notes: _notesController.text,
                                  );

                                  try {
                                    final isSuccess =
                                        await createLogisticPersonUseCase
                                            .execute(newLogisticPerson);
                                    if (isSuccess) {
                                      SnackBarUtils.showSuccessSnackBar(
                                        context,
                                        'Logistic Person created successfully',
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      SnackBarUtils.showErrorSnackBar(
                                        context,
                                        'Failed to create logistic person. Please try again.',
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
                              child: const Text('Create Logistic Person'),
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
