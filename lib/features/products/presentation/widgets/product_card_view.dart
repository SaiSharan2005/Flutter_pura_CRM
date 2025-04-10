import 'package:flutter/material.dart'; 
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';

class ProductCardView extends StatelessWidget {
  final Product product;
  final Function(int?)? onTap;

  const ProductCardView({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get the first variant's first image URL (without fallback)
    String? imageUrl;
    if (product.variants.isNotEmpty &&
        product.variants.first.imageUrls.isNotEmpty) {
      imageUrl = product.variants.first.imageUrls.first.imageUrl;
      ;
    }

    // Get price from first variant if available
    String priceText = product.variants.isNotEmpty
        ? '\$${product.variants.first.price.toStringAsFixed(2)}'
        : 'N/A';

    return GestureDetector(
      onTap: () => onTap?.call(product.id),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (ONLY if available)
            if (imageUrl != null && imageUrl.isNotEmpty)
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceText,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
