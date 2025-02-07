// user_deals_page.dart

import 'package:flutter/material.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_deals_of_user_usecase.dart';

class UserDealsPage extends StatelessWidget {
  final GetDealsOfUserUseCase getDealsOfUserUseCase;
  final int userId; // The ID of the user whose deals you want to display

  const UserDealsPage({
    Key? key,
    required this.getDealsOfUserUseCase,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Deals'),
      ),
      body: FutureBuilder<List<DealEntity>>(
        future: getDealsOfUserUseCase(userId), // Directly call the use case
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for the data.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If an error occurred, display the error.
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error} ${snapshot.data.toString()}'));
          }
          // If no data is available, display a message.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No deals found for this user.'));
          }
          // Once data is fetched, display it in a ListView.
          final deals = snapshot.data!;
          return ListView.builder(
            itemCount: deals.length,
            itemBuilder: (context, index) {
              final deal = deals[index];
              return ListTile(
                title: Text(deal.dealName),
                subtitle: Text(
                  'Stage: ${deal.dealStage}\nAmount: \$${deal.amount.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
