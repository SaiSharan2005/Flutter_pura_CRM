// import 'package:pura_crm/features/auth/data/models/user_model.dart';
// import 'package:pura_crm/features/auth/domain/entities/user.dart';
//
// class Salesman {
//   final UserDTO? user; // Made nullable
//   final String phoneNumber;
//   final String address;
//   final DateTime dateOfBirth;
//   final String regionAssigned;
//   final double totalSales;
//   final DateTime hireDate;
//   final String status;
//   final String? notes;
//
//   Salesman({
//     this.user, // Nullable, not required
//     required this.phoneNumber,
//     required this.address,
//     required this.dateOfBirth,
//     required this.regionAssigned,
//     required this.totalSales,
//     required this.hireDate,
//     required this.status,
//     this.notes,
//   });
//
//   // Factory method to create a Salesman from JSON
//   factory Salesman.fromJson(Map<String, dynamic> json) {
//     return Salesman(
//       user: json['user'] != null ? UserDTO.fromJson(json['user']) : null, // Check for null
//       phoneNumber: json['phoneNumber'],
//       address: json['address'],
//       dateOfBirth: DateTime.parse(json['dateOfBirth']), // Parse DateTime
//       regionAssigned: json['regionAssigned'],
//       totalSales: json['totalSales'].toDouble(), // Ensure double type
//       hireDate: DateTime.parse(json['hireDate']), // Parse DateTime
//       status: json['status'],
//       notes: json['notes'],
//     );
//   }
//
//   // Method to convert a Salesman instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'user': user?.toJson(), // Use null-aware operator
//       'phoneNumber': phoneNumber,
//       'address': address,
//       'dateOfBirth': dateOfBirth.toIso8601String(), // Convert DateTime to ISO string
//       'regionAssigned': regionAssigned,
//       'totalSales': totalSales,
//       'hireDate': hireDate.toIso8601String(), // Convert DateTime to ISO string
//       'status': status,
//       'notes': notes,
//     };
//   }
// }
