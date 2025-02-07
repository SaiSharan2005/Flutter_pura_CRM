// lib/features/deals/domain/entities/deal_entity.dart

class DealEntity {
  final int? id; // may be null when creating a deal
  final int customerId;
  final int cartId;
  final int userId;
  final String dealName;
  final String dealStage;
  final double amount;
  final int quantity;
  final String deliveryAddress;
  final DateTime expectedCloseDate;
  final DateTime? actualClosedDate;
  final String? note;

  DealEntity({
    this.id,
    required this.customerId,
    required this.cartId,
    required this.userId,
    required this.dealName,
    required this.dealStage,
    required this.amount,
    required this.quantity,
    required this.deliveryAddress,
    required this.expectedCloseDate,
    this.actualClosedDate,
    this.note,
  });
}
