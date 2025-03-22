// import 'package:pura_crm/features/products/domain/entities/inventory.dart';
import 'package:pura_crm/features/products/domain/entities/inventory.dart';

class InventoryModel extends Inventory {
  const InventoryModel({
    super.id,
    required super.quantity,
    required super.reorderLevel,
    required super.safetyStock,
    required super.lastUpdated,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'] as int?,
      quantity: json['quantity'] as int,
      reorderLevel: json['reorderLevel'] as int,
      safetyStock: json['safetyStock'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated']),
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
}
