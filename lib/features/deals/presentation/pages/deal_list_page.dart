// lib/features/deals/presentation/pages/user_deals_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/presentation/pages/deal_details_page.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';
import 'package:pura_crm/utils/dynamic_navbar.dart';

// Define your primary color.
const primaryColor = Color(0xFFE41B47);

class UserDealsPage extends StatelessWidget {
  final int userId; // The ID of the user whose deals you want to display

  const UserDealsPage({
    super.key,
    required this.userId,
  });

  // Simulated demo data for deals.
  Future<List<DealEntity>> _fetchDemoDeals() async {
    await Future.delayed(const Duration(seconds: 1));

    // Create demo Customer objects.
    final customer1 = Customer(
      id: 1,
      customerName: "John Doe",
      email: "johndoe@example.com",
      phoneNumber: "123-456-7890",
      address: "123 Elm Street, Springfield, IL, USA",
      noOfOrders: 25,
      buyerCompanyName: "Doe Enterprises",
    );
    final customer2 = Customer(
      id: 2,
      customerName: "David",
      email: "david@gmail.com",
      phoneNumber: "8125281005",
      address: "Osmangunj 5-2-778",
      noOfOrders: 0,
      buyerCompanyName: "David",
    );

    // Create demo CartEntity objects.
    final cart1 = CartEntity(
      id: 1,
      userId: userId,
      status: "ACTIVE",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      items: [], // Assume empty for demo.
    );
    final cart2 = CartEntity(
      id: 2,
      userId: userId,
      status: "ACTIVE",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      items: [],
    );

    // Create demo User (salesman) object.
    final salesman = User(
      id: userId,
      username: "salesman",
      email: "salesman@example.com",
    );

    // Create a demo deal for Cow Ghee Sale.
    final demoDeal1 = DealEntity(
      id: 1,
      customerId: customer1,
      cartId: cart1,
      userId: salesman,
      dealName: "Cow Ghee Sale",
      dealStage: "Open",
      amount: 320.00,
      quantity: 1,
      deliveryAddress: "123 Elm Street, Springfield",
      expectedCloseDate: DateTime.now().add(const Duration(days: 7)),
      actualClosedDate: null,
      note: "This is a demo deal for Cow Ghee.",
    );

    // Create a demo deal for Buffalo Ghee Discount.
    final demoDeal2 = DealEntity(
      id: 2,
      customerId: customer2,
      cartId: cart2,
      userId: salesman,
      dealName: "Buffalo Ghee Discount",
      dealStage: "Closed",
      amount: 2999.99,
      quantity: 1,
      deliveryAddress: "456 Oak Avenue, Metropolis",
      expectedCloseDate: DateTime.now().add(const Duration(days: 3)),
      actualClosedDate: DateTime.now().add(const Duration(days: 2)),
      note: "Deal closed successfully.",
    );

    return [demoDeal1, demoDeal2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'User Deals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DealEntity>>(
        future: _fetchDemoDeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No deals found for this user.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          final deals = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deals.length,
            itemBuilder: (context, index) {
              final deal = deals[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: '/deals/details'),
                      builder: (context) => MainLayout(
                        child: DealDetailsPage(deal: deal),
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.dealName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${deal.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: deal.dealStage.toLowerCase() == 'closed'
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                deal.dealStage,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.redAccent),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                deal.deliveryAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Expected Close: ${DateFormat.yMMMd().format(deal.expectedCloseDate)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Floating Action Button to create a new deal.
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed('/deals/create');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
