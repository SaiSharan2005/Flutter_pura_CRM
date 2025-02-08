import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';

class CustomerModel extends Customer {
  CustomerModel({
    required int id,
    required String customerName,
    required String email,
    required String phoneNumber,
    required String address,
    required int noOfOrders,
    required String buyerCompanyName,
  }) : super(
          id: id,
          customerName: customerName,
          email: email,
          phoneNumber: phoneNumber,
          address: address,
          noOfOrders: noOfOrders,
          buyerCompanyName: buyerCompanyName,
        );

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
