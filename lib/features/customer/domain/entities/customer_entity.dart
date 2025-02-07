class Customer {
  final int id;
  final String customerName;
  final String email;
  final String phoneNumber;
  final String address;
  final int noOfOrders;
  final String buyerCompanyName;

  Customer({
    required this.id,
    required this.customerName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.noOfOrders,
    required this.buyerCompanyName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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
