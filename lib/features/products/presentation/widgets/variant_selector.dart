import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

class VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant selectedVariant;
  final ValueChanged<ProductVariant> onVariantSelected;

  const VariantSelector({
    Key? key,
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: variants.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final variant = variants[index];
          bool isSelected = variant.id == selectedVariant.id;
          return GestureDetector(
            onTap: () => onVariantSelected(variant),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (variant.imageUrls.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        variant.imageUrls.first.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(height: 50, width: 50, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(variant.variantName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
