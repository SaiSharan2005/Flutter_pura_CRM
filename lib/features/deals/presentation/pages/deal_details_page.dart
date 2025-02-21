import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';

class DealDetailsPage extends StatelessWidget {
  final DealEntity deal;

  const DealDetailsPage({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE41B47);

    // Format dates.
    final formattedExpectedDate =
        DateFormat.yMMMd().format(deal.expectedCloseDate);
    final formattedActualDate = (deal.actualClosedDate == DateTime(2000, 1, 1))
        ? "-"
        : DateFormat.yMMMd().format(deal.actualClosedDate);

    final formattedUpdatedDate = (deal.cartId.updatedAt == null ||
            deal.cartId.updatedAt == DateTime(2000, 1, 1))
        ? "-"
        : DateFormat.yMMMd().format(deal.cartId.updatedAt!);

    // Placeholder values for createdAt/updatedAt.
    // final cartCreatedAt = "Unknown";
    // final cartUpdatedAt = "Unknown";

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
            // Deal Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
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
            // Deal Information Section
            _buildExpansionSection(
              title: "Deal Information",
              children: [
                _buildDetailRow("Stage", deal.dealStage),
                _buildDetailRow(
                    "Amount", "\$${deal.amount.toStringAsFixed(2)}"),
                _buildDetailRow("Quantity", deal.quantity.toString()),
                _buildDetailRow("Delivery Address", deal.deliveryAddress),
                _buildDetailRow("Expected Close", formattedExpectedDate),
                _buildDetailRow("Actual Close", formattedActualDate),
                if (deal.note.isNotEmpty) _buildDetailRow("Note", deal.note),
              ],
            ),
            const SizedBox(height: 20),
            // Customer Details Section
            _buildExpansionSection(
              title: "Customer Details",
              children: [
                _buildDetailRow("Name", deal.customerId.customerName ?? "N/A"),
                _buildDetailRow("Email", deal.customerId.email ?? "N/A"),
                _buildDetailRow("Phone", deal.customerId.phoneNumber ?? "N/A"),
                _buildDetailRow("Address", deal.customerId.address ?? "N/A"),
                _buildDetailRow(
                    "Orders", deal.customerId.noOfOrders.toString() ?? "0"),
                _buildDetailRow(
                    "Company", deal.customerId.buyerCompanyName ?? "N/A"),
              ],
            ),
            const SizedBox(height: 20),
            // Cart Details Section (with status badge)
            _buildExpansionSection(
              title: "Cart Details",
              trailingWidget: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue, // Badge color for cart status.
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  deal.cartId.status,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                _buildDetailRow("Cart ID", deal.cartId.id.toString()),
                _buildDetailRow("Created At",
                    DateFormat.yMMMd().format(deal.cartId.createdAt)),
                _buildDetailRow("Updated At", formattedUpdatedDate),
              ],
            ),
            const SizedBox(height: 20),
            // Cart Items Section
            _buildExpansionSection(
              title: "Cart Items",
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: 20,
                          dataRowHeight: 70,
                          headingRowHeight: 56,
                          headingRowColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.grey[200],
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Product',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Quantity',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: deal.cartId.items.map((item) {
                            return DataRow(cells: [
                              DataCell(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              DataCell(Text(item.product.productName)),
                              DataCell(
                                SizedBox(
                                  width: 50, // Small width for quantity column.
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                  Text("\$${item.price.toStringAsFixed(2)}")),
                              DataCell(Text(
                                  "\$${item.totalPrice.toStringAsFixed(2)}")),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Salesman Details Section
            _buildExpansionSection(
              title: "Salesman Details",
              children: [
                _buildDetailRow("Username", deal.userId.username),
                _buildDetailRow("Email", deal.userId.email),
              ],
            ),
            const SizedBox(height: 20),
            // Deal Stage Section
            _buildExpansionSection(
              title: "Deal Stage",
              children: [
                _buildDealStages(primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an expansion section with a custom title, optional trailing widget, and child widgets.
  Widget _buildExpansionSection({
    required String title,
    Widget? trailingWidget,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailingWidget ?? const Icon(Icons.keyboard_arrow_down),
        children: children,
      ),
    );
  }

  /// Builds a detail row with a label and value.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
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

  /// Builds a horizontal deal stages widget.
  /// Builds a vertical list of deal stages.
  Widget _buildDealStages(Color primaryColor) {
    // Define your stages.
    final stages = [
      "Deal Initiation",
      "Admin Approval",
      "Delivery Assignment",
      "Order Delivery",
      "Payment Confirmation",
      "Deal Closure"
    ];

    // Determine the current stage index by matching deal.dealStage.
    int currentStageIndex = stages.indexOf(deal.dealStage);
    if (currentStageIndex < 0) currentStageIndex = 0; // Fallback if not found.

    return Column(
      children: List.generate(stages.length, (index) {
        final isActive = index <= currentStageIndex;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicator column.
            Column(
              children: [
                // The circle indicator.
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isActive ? primaryColor : Colors.grey[300],
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // The vertical line connecting to the next step (if not the last step).
                if (index != stages.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: (index < currentStageIndex)
                        ? primaryColor
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Stage name.
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  stages[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? primaryColor : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
