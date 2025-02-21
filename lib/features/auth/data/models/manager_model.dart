import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';

class ManagerModel extends ManagerEntity {
  ManagerModel({
    required super.phoneNumber,
    required super.address,
    required super.dateOfBirth,
    required super.status,
    required super.hireDate,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      status: json['status'],
      hireDate: DateTime.parse(json['hireDate']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'status': status,
      'hireDate': hireDate.toIso8601String(),
    };
  }
}
