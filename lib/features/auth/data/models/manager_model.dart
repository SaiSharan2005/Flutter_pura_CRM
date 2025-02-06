import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';



class ManagerModel extends ManagerEntity {
  ManagerModel({
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
    required String status,
    required DateTime hireDate,
  }) : super(
    phoneNumber: phoneNumber,
    address: address,
    dateOfBirth: dateOfBirth,
    status: status,
    hireDate: hireDate,
  );

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      status: json['status'],
      hireDate: DateTime.parse(json['hireDate']),
    );
  }

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
