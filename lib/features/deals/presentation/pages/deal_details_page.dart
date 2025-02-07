import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';

class DealDetailsPage extends StatelessWidget {
  final DealEntity deal;

  const DealDetailsPage({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);

    // Format the expected and actual close dates.
    final formattedExpectedDate =
        DateFormat.yMMMd().format(deal.expectedCloseDate);
    final formattedActualDate = deal.actualClosedDate != null
        ? DateFormat.yMMMd().format(deal.actualClosedDate!)
        : "Not Closed Yet";

    // Use placeholder values for createdAt/updatedAt if not available.
    final cartCreatedAt = "Unknown";
    final cartUpdatedAt = "Unknown";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Deal Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Deal Name.
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                deal.dealName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader("Deal Information"),
            _buildDetailRow("Stage", deal.dealStage),
            _buildDetailRow("Amount", "\$${deal.amount.toStringAsFixed(2)}"),
            _buildDetailRow("Quantity", deal.quantity.toString()),
            _buildDetailRow("Delivery Address", deal.deliveryAddress),
            _buildDetailRow("Expected Close", formattedExpectedDate),
            _buildDetailRow("Actual Close", formattedActualDate),
            if (deal.note != null && deal.note!.isNotEmpty)
              _buildDetailRow("Note", deal.note!),
            const SizedBox(height: 20),
            _buildSectionHeader("Customer Details"),
            // _buildDetailRow("Name", deal.customerId.customerName ?? "N/A"),
            // _buildDetailRow("Email", deal.customerId.email ?? "N/A"),
            // _buildDetailRow("Phone", deal.customerId.phoneNumber ?? "N/A"),
            // _buildDetailRow("Address", deal.customerId.address ?? "N/A"),
            // _buildDetailRow(
            //     "Orders", deal.customerId.noOfOrders?.toString() ?? "0"),
            // _buildDetailRow(
            //     "Company", deal.customerId.buyerCompanyName ?? "N/A"),
            // const SizedBox(height: 20),
            // _buildSectionHeader("Cart Details"),
            // _buildDetailRow("Cart ID", deal.cartId.id.toString()),
            // _buildDetailRow("Items", deal.cartId.items.length.toString()),
            // _buildDetailRow("Created At", cartCreatedAt),
            // _buildDetailRow("Status", deal.cartId.status),
            _buildDetailRow("Updated At", cartUpdatedAt),
            const SizedBox(height: 20),
            _buildSectionHeader("Salesman Details"),
            // _buildDetailRow("Username", deal.userId.username),
            // _buildDetailRow("Email", deal.userId.email),
          ],
        ),
      ),
    );
  }

  /// Helper method to build section headers.
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Divider(thickness: 2, color: Colors.grey),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Helper method to build detail rows.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
