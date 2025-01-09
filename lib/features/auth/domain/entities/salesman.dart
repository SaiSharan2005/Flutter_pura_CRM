class Salesman {
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;
  final String regionAssigned;
  final double totalSales;
  final DateTime hireDate;
  final String status;
  final String? notes;

  Salesman({
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

  // Method to convert a Salesman instance to JSON
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
