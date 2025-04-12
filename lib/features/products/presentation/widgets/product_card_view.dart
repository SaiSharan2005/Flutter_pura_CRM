import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class ProductCardView extends StatelessWidget {
  final Product product;
  /// [onTap] returns either a [Product] or an identifier, depending on how you use it.
  final Function(dynamic)? onTap;

  const ProductCardView({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (product.variants.isNotEmpty && product.variants.first.imageUrls.isNotEmpty) {
      imageUrl = product.variants.first.imageUrls.first.imageUrl;
    }

    String priceText = product.variants.isNotEmpty
        ? '\$${product.variants.first.price.toStringAsFixed(2)}'
        : 'N/A';

    return GestureDetector(
      onTap: () => onTap?.call(product),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceText,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
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
