import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';

class ProductDetailsPage extends StatefulWidget {
  final GetProductByIdUseCase getProductByIdUseCase;
  final int productId;

  const ProductDetailsPage({
    Key? key,
    required this.getProductByIdUseCase,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.getProductByIdUseCase.call(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No product data found.',
                  style: TextStyle(fontSize: 16)),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product),
                  const SizedBox(height: 16),
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.productStatus == 'Available'
                        ? 'In stock'
                        : 'Out of stock',
                    style: TextStyle(
                      fontSize: 16,
                      color: product.productStatus == 'Available'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSpecifications(product),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/logo.png'), // Replace with product image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecifications(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // _buildDetailRow('Color', product.color ?? 'Black'),
        _buildDetailRow('Size', 'One size'),
        _buildDetailRow('Dimensions', product.dimensions ?? 'N/A'),
        _buildDetailRow('Weight', '${product.weight} lbs'),
        _buildDetailRow(
            'Warranty',
            product.warrantyPeriod != null
                ? '${product.warrantyPeriod} months'
                : 'Lifetime'),
        _buildDetailRow('SKU', product.sku ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add to bag',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
