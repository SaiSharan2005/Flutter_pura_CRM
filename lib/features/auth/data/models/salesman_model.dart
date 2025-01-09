import 'package:pura_crm/features/auth/domain/entities/salesman.dart';


class SalesmanModel extends Salesman {
  SalesmanModel({
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
    required String regionAssigned,
    required double totalSales,
    required DateTime hireDate,
    required String status,
    String? notes,
  }) : super(
    phoneNumber: phoneNumber,
    address: address,
    dateOfBirth: dateOfBirth,
    regionAssigned: regionAssigned,
    totalSales: totalSales,
    hireDate: hireDate,
    status: status,
    notes: notes,
  );

  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'],
      regionAssigned: json['regionAssigned'],
      totalSales: json['totalSales'],
      hireDate: json['hireDate'],
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'regionAssigned': regionAssigned,
      'totalSales': totalSales,
      'hireDate': hireDate,
      'status': status,
      'notes': notes,
    };
  }
}
