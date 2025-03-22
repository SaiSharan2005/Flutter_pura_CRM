import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';

class VariantDetails extends StatelessWidget {
  final ProductVariant variant;
  const VariantDetails({Key? key, required this.variant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(variant.variantName,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 20, color: Colors.green),
                const SizedBox(width: 4),
                Text(variant.price.toStringAsFixed(2),
                    style:
                        const TextStyle(fontSize: 18, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.qr_code, size: 20, color: Colors.blue),
                const SizedBox(width: 4),
                Text(variant.sku,
                    style:
                        const TextStyle(fontSize: 18, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.dashboard, size: 20, color: Colors.deepPurple),
                const SizedBox(width: 4),
                Text(variant.units,
                    style: const TextStyle(fontSize: 18, color: Colors.black87)),
              ],
            ),
            if (variant.inventories.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text('Inventory Details:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 8),
              Column(
                children: variant.inventories.map((inventory) {
                  return Row(
                    children: [
                      const Icon(Icons.inventory,
                          size: 18, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Qty: ${inventory.quantity}, Reorder: ${inventory.reorderLevel}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
