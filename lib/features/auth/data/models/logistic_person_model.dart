import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';

class LogisticPersonModel extends LogisticPersonEntity {
  LogisticPersonModel({
    required super.phoneNumber,
    required super.address,
    required super.dateOfBirth,
    required super.deliveryAreas,
    required super.vehicleInfo,
    required super.licenseNumber,
    required super.status,
    super.notes,
  });

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

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
