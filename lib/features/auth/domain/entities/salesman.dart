
import 'package:pura_crm/features/auth/domain/entities/user.dart';

class Salesman {
  final User? user; // Nullable
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String regionAssigned;
  final double totalSales;
  final DateTime hireDate;
  final String status;
  final String? notes;

  Salesman({
    this.user,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.regionAssigned,
    required this.totalSales,
    required this.hireDate,
    required this.status,
    this.notes,
  });

  // Factory method to create a Salesman from JSON
  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      // user: json['user'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      regionAssigned: json['regionAssigned'],
      totalSales: (json['totalSales'] as num).toDouble(), // Ensure double
      hireDate: DateTime.parse(json['hireDate']),
      status: json['status'],
      notes: json['notes'],
    );
  }

  // Method to convert a Salesman instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'regionAssigned': regionAssigned,
      'totalSales': totalSales,
      'hireDate': hireDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
