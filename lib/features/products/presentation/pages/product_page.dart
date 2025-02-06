import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';
// import 'package:pura_crm/features/products/domain/usecases/create_product_usecase.dart';
// import 'package:pura_crm/core/utils/snackbar_utils.dart'; // Import SnackBarUtils

class ProductCreatePage extends StatefulWidget {
  final CreateProductUseCase createProductUseCase;

  ProductCreatePage({required this.createProductUseCase});

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _productStatus = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
        backgroundColor: Color(0xFFE41B47),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE41B47), Color(0xFFF78DA7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Title
                  Text(
                    'Add a New Product',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),

                  // Form Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildTextField(
                              controller: _productNameController,
                              label: 'Product Name',
                              icon: Icons.production_quantity_limits,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter product name' : null,
                            ),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Description',
                              icon: Icons.description,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter description' : null,
                            ),
                            _buildTextField(
                              controller: _priceController,
                              label: 'Price',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter price' : null,
                            ),
                            _buildTextField(
                              controller: _skuController,
                              label: 'SKU',
                              icon: Icons.qr_code,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter SKU' : null,
                            ),
                            _buildTextField(
                              controller: _quantityController,
                              label: 'Quantity Available',
                              icon: Icons.add_shopping_cart,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Enter quantity available'
                                  : null,
                            ),
                            _buildTextField(
                              controller: _dimensionsController,
                              label: 'Dimensions',
                              icon: Icons.straighten,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter dimensions' : null,
                            ),
                            _buildTextField(
                              controller: _warrantyController,
                              label: 'Warranty Period (Months)',
                              icon: Icons.verified_user,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Enter warranty period'
                                  : null,
                            ),
                            _buildTextField(
                              controller: _weightController,
                              label: 'Weight (kg)',
                              icon: Icons.scale,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter weight' : null,
                            ),
                            SizedBox(height: 16),

                            // Product Status Dropdown
                            DropdownButtonFormField<String>(
                              value: _productStatus,
                              decoration: InputDecoration(
                                labelText: 'Product Status',
                                prefixIcon: Icon(Icons.flag, color: Colors.red),
                                border: OutlineInputBorder(),
                              ),
                              items: ['Active', 'Inactive']
                                  .map(
                                    (status) => DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _productStatus = value!;
                                });
                              },
                            ),
                            SizedBox(height: 24),

                            // Submit Button
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final newProduct = ProductModel(
                                    id: null, // Optional
                                    productName: _productNameController.text,
                                    description: _descriptionController.text,
                                    price: double.parse(_priceController.text),
                                    sku: _skuController.text,
                                    productStatus: _productStatus,
                                    quantityAvailable:
                                        int.parse(_quantityController.text),
                                    dimensions: _dimensionsController.text,
                                    warrantyPeriod:
                                        int.parse(_warrantyController.text),
                                    weight:
                                        double.parse(_weightController.text),
                                  );

                                  try {
                                    await widget
                                        .createProductUseCase(newProduct);
                                    SnackBarUtils.showSuccessSnackBar(context,
                                        'Product created successfully!');
                                    Navigator.pop(context);
                                  } catch (error) {
                                    SnackBarUtils.showErrorSnackBar(
                                        context, 'Error: ${error.toString()}');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE41B47),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text('Create Product'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Utility method for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.red),
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
