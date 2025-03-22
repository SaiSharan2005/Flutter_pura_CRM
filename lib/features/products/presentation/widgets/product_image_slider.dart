import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

class ProductImageSlider extends StatelessWidget {
  final ProductVariant variant;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ProductImageSlider({
    Key? key,
    required this.variant,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls =
        variant.imageUrls.map((e) => e.imageUrl).toList();
    if (imageUrls.isEmpty) imageUrls.add('assets/logo.png');

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl.startsWith('http')
                    ? Image.network(imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover)
                    : Image.asset(imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageUrls.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == entry.key ? Colors.black : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
