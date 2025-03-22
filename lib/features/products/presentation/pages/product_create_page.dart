import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pura_crm/features/products/data/models/inventory_model.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';
import 'package:pura_crm/features/products/data/models/product_variant_image_model.dart';
import 'package:pura_crm/features/products/data/models/product_variant_model.dart';
import 'package:pura_crm/features/products/domain/usecases/create_product_usecase.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

/// Add a copyWith method to update fields immutably.
extension ProductVariantModelCopy on ProductVariantModel {
  ProductVariantModel copyWith({
    int? id,
    String? variantName,
    double? price,
    String? sku,
    String? units,
    DateTime? createdDate,
    DateTime? updatedDate,
    List<ProductVariantImageModel>? imageUrls,
    List<InventoryModel>? inventories,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      variantName: variantName ?? this.variantName,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      units: units ?? this.units,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      imageUrls: imageUrls ?? this.imageUrls,
      inventories: inventories ?? this.inventories,
    );
  }
}

class ProductCreatePage extends StatefulWidget {
  final CreateProductUseCase createProductUseCase;

  const ProductCreatePage({super.key, required this.createProductUseCase});

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _productStatus = 'Active';
  List<ProductVariantModel> _variants = [];

  void _addVariant() {
    setState(() {
      _variants.add(ProductVariantModel(
        id: null,
        variantName: '',
        price: 0.0,
        sku: '',
        units: '',
        createdDate: DateTime.now(),
        imageUrls: [],
        inventories: [],
      ));
    });
  }

  void _updateVariant(int index, ProductVariantModel updatedVariant) {
    setState(() {
      _variants[index] = updatedVariant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        backgroundColor: const Color(0xFFE41B47),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _productStatus,
                  decoration: InputDecoration(
                    labelText: 'Product Status',
                    prefixIcon: const Icon(Icons.flag, color: Colors.red),
                    border: OutlineInputBorder(),
                  ),
                  items: ['Active', 'Inactive']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _productStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // Display a card for each variant.
                ..._variants.asMap().entries.map((entry) {
                  int index = entry.key;
                  ProductVariantModel variant = entry.value;
                  return VariantCardView(
                    index: index,
                    variant: variant,
                    onVariantChanged: (updatedVariant) =>
                        _updateVariant(index, updatedVariant),
                  );
                }).toList(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _addVariant,
                  icon: const Icon(Icons.add, color: Colors.red),
                  label: const Text(
                    'Add Variant',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newProduct = ProductModel(
                        id: null,
                        productName: _productNameController.text,
                        description: _descriptionController.text,
                        productStatus: _productStatus,
                        createdDate: DateTime.now(),
                        variants: _variants,
                      );

                      try {
                        await widget.createProductUseCase(newProduct);
                        SnackBarUtils.showSuccessSnackBar(
                            context, 'Product created successfully!');
                        Navigator.pop(context);
                      } catch (error) {
                        SnackBarUtils.showErrorSnackBar(
                            context, 'Error: ${error.toString()}');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE41B47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Create Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
    );
  }
}

class VariantCardView extends StatefulWidget {
  final int index;
  final ProductVariantModel variant;
  final Function(ProductVariantModel) onVariantChanged;

  const VariantCardView({
    Key? key,
    required this.index,
    required this.variant,
    required this.onVariantChanged,
  }) : super(key: key);

  @override
  _VariantCardViewState createState() => _VariantCardViewState();
}

class _VariantCardViewState extends State<VariantCardView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _unitsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.variant.variantName);
    _priceController =
        TextEditingController(text: widget.variant.price.toString());
    _skuController = TextEditingController(text: widget.variant.sku);
    _unitsController = TextEditingController(text: widget.variant.units);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Optionally, update variant.imageUrls here if you wish.
    }
  }

  Widget _buildVariantImage() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (widget.variant.imageUrls.isNotEmpty) {
      // Display the first image from the variant's imageUrls.
      return Image.network(
        widget.variant.imageUrls.first.imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox();
    }
  }

  void _onNameChanged(String value) {
    final updatedVariant = widget.variant.copyWith(variantName: value);
    widget.onVariantChanged(updatedVariant);
  }

  void _onPriceChanged(String value) {
    final price = double.tryParse(value) ?? 0.0;
    final updatedVariant = widget.variant.copyWith(price: price);
    widget.onVariantChanged(updatedVariant);
  }

  void _onSkuChanged(String value) {
    final updatedVariant = widget.variant.copyWith(sku: value);
    widget.onVariantChanged(updatedVariant);
  }

  void _onUnitsChanged(String value) {
    final updatedVariant = widget.variant.copyWith(units: value);
    widget.onVariantChanged(updatedVariant);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Variant Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Variant Name',
                prefixIcon: const Icon(Icons.edit, color: Colors.red),
                border: OutlineInputBorder(),
              ),
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 8),
            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                prefixIcon: const Icon(Icons.attach_money, color: Colors.red),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: _onPriceChanged,
            ),
            const SizedBox(height: 8),
            // SKU Field
            TextFormField(
              controller: _skuController,
              decoration: InputDecoration(
                labelText: 'SKU',
                prefixIcon:
                    const Icon(Icons.confirmation_number, color: Colors.red),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSkuChanged,
            ),
            const SizedBox(height: 8),
            // Units Field
            TextFormField(
              controller: _unitsController,
              decoration: InputDecoration(
                labelText: 'Units',
                prefixIcon: const Icon(Icons.list_alt, color: Colors.red),
                border: OutlineInputBorder(),
              ),
              onChanged: _onUnitsChanged,
            ),
            const SizedBox(height: 8),
            // Upload Image Button
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image, color: Colors.blue),
              label: const Text(
                'Upload Image',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 8),
            // Display Variant Image
            _buildVariantImage(),
          ],
        ),
      ),
    );
  }
}
