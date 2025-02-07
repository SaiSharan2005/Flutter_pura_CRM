import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/products/domain/entities/cart_entity.dart';

class DealModel extends DealEntity {
  DealModel({
    int? id,
    required Customer customerId,
    required CartEntity cartId,
    required User userId,
    required String dealName,
    required String dealStage,
    required double amount,
    required int quantity,
    required String deliveryAddress,
    required DateTime expectedCloseDate,
    DateTime? actualClosedDate,
    String? note,
  }) : super(
          id: id ?? 0,
          customerId: customerId,
          cartId: cartId,
          userId: userId,
          dealName: dealName,
          dealStage: dealStage,
          amount: amount,
          quantity: quantity,
          deliveryAddress: deliveryAddress,
          expectedCloseDate: expectedCloseDate,
          actualClosedDate: actualClosedDate ?? DateTime(2000, 1, 1),
          note: note ?? '',
        );

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id'] ?? 0,
      customerId: json['customerId'] != null
          ? Customer.fromJson(json['customerId'] as Map<String, dynamic>)
          : throw Exception('Missing customer data'),
      cartId: json['cartId'] != null
          ? CartEntity.fromJson(json['cartId'] as Map<String, dynamic>)
          : throw Exception('Missing cart data'),
      userId: json['userId'] != null
          ? User.fromJson(json['userId'] as Map<String, dynamic>)
          : throw Exception('Missing user data'),
      dealName: json['dealName'] ?? '',
      dealStage: json['dealStage'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      deliveryAddress: json['deliveryAddress'] ?? '',
      expectedCloseDate: json['expectedCloseDate'] != null
          ? DateTime.tryParse(json['expectedCloseDate'].toString()) ??
              DateTime(2000, 1, 1)
          : DateTime(2000, 1, 1),
      // Always provide a DateTime (using default if actualClosedDate is null or empty)
      actualClosedDate: json['actualClosedDate'] != null &&
              json['actualClosedDate'].toString().isNotEmpty
          ? (DateTime.tryParse(json['actualClosedDate'].toString()) ??
              DateTime(2000, 1, 1))
          : DateTime(2000, 1, 1),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId.toJson(),
      'cartId': cartId.toJson(),
      'userId': userId.toJson(),
      'dealName': dealName,
      'dealStage': dealStage,
      'amount': amount,
      'quantity': quantity,
      'deliveryAddress': deliveryAddress,
      'expectedCloseDate': expectedCloseDate.toIso8601String(),
      'actualClosedDate': actualClosedDate.toIso8601String(),
      'note': note,
    };
  }
}
