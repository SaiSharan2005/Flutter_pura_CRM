class ManagerEntity {
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String status;
  final DateTime hireDate;

  ManagerEntity({
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.status,
    required this.hireDate,
  });

  // fromJson method to convert JSON into a ManagerEntity object
  factory ManagerEntity.fromJson(Map<String, dynamic> json) {
    return ManagerEntity(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      status: json['status'],
      hireDate: DateTime.parse(json['hireDate']),
    );
  }

  // toJson method to convert ManagerEntity object into JSON
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
