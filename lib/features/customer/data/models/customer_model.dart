import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required super.id,
    required super.customerName,
    required super.email,
    required super.phoneNumber,
    required super.address,
    required super.noOfOrders,
    required super.buyerCompanyName,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      customerName: json['customerName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      noOfOrders: json['noOfOrders'] ?? 0,
      buyerCompanyName: json['buyerCompanyName'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'noOfOrders': noOfOrders,
      'buyerCompanyName': buyerCompanyName,
    };
  }
}
