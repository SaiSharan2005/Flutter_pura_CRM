// lib/features/deals/presentation/widgets/deal_card.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:intl/intl.dart';

class DealCard extends StatelessWidget {
  final DealEntity deal;
  const DealCard({super.key, required this.deal});
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMd().format(deal.expectedCloseDate);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(deal.dealName),
        subtitle:
            Text('Stage: ${deal.dealStage}\nExpected Close: $formattedDate'),
        trailing: Text('\$${deal.amount.toStringAsFixed(2)}'),
      ),
    );
  }
}
