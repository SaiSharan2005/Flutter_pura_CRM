import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class ProductCardView extends StatelessWidget {
  final Product product;
  final Function(int?)? onTap;

  const ProductCardView({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(product.id),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            // Left-side image (takes as much space as allocated)
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Curved edges
                  child: Container(
                    height: 100, // Adjust height as needed
                    width: 100, // Adjust width as needed
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Optional background color
                      borderRadius: BorderRadius.circular(
                          20), // Matches the ClipRRect radius
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit
                          .contain, // Ensures the entire image fits without cropping
                    ),
                  ),
                ),

                //  Image.network(
                //   'https://via.placeholder.com/150', // Replace with product.image if available
                //   fit: BoxFit.cover, // Ensures the image fills the space
                //   width: double.infinity,
                //   height: double.infinity,
                // ),
              ),
            ),
            // Right-side details
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Product name
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Product price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Quantity available
                    Text(
                      'Quantity: ${product.quantityAvailable}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Product status
                    Row(
                      children: [
                        Icon(
                          product.productStatus == 'Available'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: product.productStatus == 'Available'
                              ? Colors.green
                              : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.productStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: product.productStatus == 'Available'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
