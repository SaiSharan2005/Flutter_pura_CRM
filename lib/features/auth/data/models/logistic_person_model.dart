import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';

class LogisticPersonModel extends LogisticPersonEntity {
  LogisticPersonModel({
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
    required String deliveryAreas,
    required String vehicleInfo,
    required String licenseNumber,
    required String status,
    String? notes,
  }) : super(
    phoneNumber: phoneNumber,
    address: address,
    dateOfBirth: dateOfBirth,
    deliveryAreas: deliveryAreas,
    vehicleInfo: vehicleInfo,
    licenseNumber: licenseNumber,
    status: status,
    notes: notes,
  );

  factory LogisticPersonModel.fromJson(Map<String, dynamic> json) {
    return LogisticPersonModel(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      deliveryAreas: json['deliveryAreas'],
      vehicleInfo: json['vehicleInfo'],
      licenseNumber: json['licenseNumber'],
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
