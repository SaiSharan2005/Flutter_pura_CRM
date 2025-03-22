import 'package:equatable/equatable.dart';

class Inventory extends Equatable {
  final int? id;
  final int quantity;
  final int reorderLevel;
  final int safetyStock;
  final DateTime lastUpdated;

  const Inventory({
    this.id,
    required this.quantity,
    required this.reorderLevel,
    required this.safetyStock,
    required this.lastUpdated,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'] as int?,
      quantity: json['quantity'] ?? 0,
      reorderLevel: json['reorderLevel'] ?? 0,
      safetyStock: json['safetyStock'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'reorderLevel': reorderLevel,
      'safetyStock': safetyStock,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [id, quantity, reorderLevel, safetyStock, lastUpdated];
}
