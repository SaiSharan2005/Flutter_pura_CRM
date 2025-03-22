import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  const ProductInfoSection({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.productName,
            style:
                const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(product.description, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          'Status: ${product.productStatus}',
          style: TextStyle(
              fontSize: 16,
              color: product.productStatus == 'Active'
                  ? Colors.green
                  : Colors.red),
        ),
      ],
    );
  }
}
