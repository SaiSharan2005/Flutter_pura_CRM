class LogisticPersonEntity {
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String deliveryAreas;
  final String vehicleInfo;
  final String licenseNumber;
  final String status;
  final String? notes;

  LogisticPersonEntity({
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.deliveryAreas,
    required this.vehicleInfo,
    required this.licenseNumber,
    required this.status,
    this.notes,
  });

  factory LogisticPersonEntity.fromJson(Map<String, dynamic> json) {
    return LogisticPersonEntity(
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
    return {
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'deliveryAreas': deliveryAreas,
      'vehicleInfo': vehicleInfo,
      'licenseNumber': licenseNumber,
      'status': status,
      'notes': notes,
    };
  }
}
