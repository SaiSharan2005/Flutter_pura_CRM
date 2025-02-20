import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';

class DealEntity {
  final int? id;
  final Customer customerId;
  final CartEntity cartId;
  final User userId;
  final String dealName;
  final String dealStage;
  final double amount;
  final int quantity;
  final String deliveryAddress;
  final DateTime expectedCloseDate;
  final DateTime actualClosedDate;
  final String note;

  DealEntity({
    int? id,
    required this.customerId,
    required this.cartId,
    required this.userId,
    required this.dealName,
    required this.dealStage,
    required this.amount,
    required this.quantity,
    required this.deliveryAddress,
    required this.expectedCloseDate,
    DateTime? actualClosedDate,
    String? note,
  })  : id = id ?? 0,
        actualClosedDate = actualClosedDate ?? DateTime(2000, 1, 1),
        note = note ?? '';

  factory DealEntity.fromJson(Map<String, dynamic> json) {
    return DealEntity(
      id: json['id'] ?? 0,
      customerId: Customer.fromJson(json['customerId']),
      cartId: CartEntity.fromJson(json['cartId']),
      userId: User.fromJson(json['userId']),
      dealName: json['dealName'] ?? '',
      dealStage: json['dealStage'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      deliveryAddress: json['deliveryAddress'] ?? '',
      expectedCloseDate: json['expectedCloseDate'] != null
          ? DateTime.tryParse(json['expectedCloseDate'].toString()) ??
              DateTime(2000, 1, 1)
          : DateTime(2000, 1, 1),
      actualClosedDate: json['actualClosedDate'] != null &&
              json['actualClosedDate'].toString().isNotEmpty
          ? (DateTime.tryParse(json['actualClosedDate'].toString()) ??
              DateTime(2000, 1, 1))
          : DateTime(2000, 1, 1),
      note: json['note'] ?? '',
    );
  }
  @override
  String toString() {
    return 'DealEntity(id: $id, dealName: $dealName, dealStage: $dealStage, amount: $amount, quantity: $quantity, deliveryAddress: $deliveryAddress, expectedCloseDate: $expectedCloseDate, actualClosedDate: $actualClosedDate, note: $note, customer: $customerId, cart: $cartId, user: $userId)';
  }
}
