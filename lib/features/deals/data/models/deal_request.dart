class DealRequestDto {
  final int? id; // Nullable for optional use during updates.
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

  DealRequestDto({
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

  // Converts a JSON map into a DealRequestDto instance.
  factory DealRequestDto.fromJson(Map<String, dynamic> json) {
    return DealRequestDto(
      id: json['id'],
      customerId: json['customerId'],
      cartId: json['cartId'],
      userId: json['userId'],
      dealName: json['dealName'],
      dealStage: json['dealStage'],
      amount: json['amount'],
      quantity: json['quantity'],
      deliveryAddress: json['deliveryAddress'],
      expectedCloseDate: DateTime.parse(json['expectedCloseDate']),
      actualClosedDate: json['actualClosedDate'] != null
          ? DateTime.parse(json['actualClosedDate'])
          : null,
      note: json['note'],
    );
  }

  // Converts a DealRequestDto instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'cartId': cartId,
      'userId': userId,
      'dealName': dealName,
      'dealStage': dealStage,
      'amount': amount,
      'quantity': quantity,
      'deliveryAddress': deliveryAddress,
      'expectedCloseDate': expectedCloseDate.toIso8601String(),
      'actualClosedDate': actualClosedDate?.toIso8601String(),
      'note': note,
    };
  }
}
