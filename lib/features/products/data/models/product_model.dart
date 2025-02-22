import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id, // Optional to handle creation without ID
    required super.productName,
    required super.description,
    required super.price,
    required super.sku,
    required super.productStatus,
    required super.quantityAvailable,
    required super.dimensions,
    required super.warrantyPeriod,
    required super.weight,
    super.user,
  });

  /// Factory constructor to create a [ProductModel] from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?, // Handle nullable ID
      productName: json['productName'] ?? 'Unknown', // Default value for null
      description: json['description'] ?? 'No description available',
      price: json['price'] != null
          ? (json['price'] as num).toDouble()
          : 0.0, // Ensure double
      sku: json['sku'] ?? 'N/A',
      productStatus: json['productStatus'] ?? 'Unavailable',
      quantityAvailable: json['quantityAvailable'] ?? 0,
      dimensions: json['dimensions'] ?? 'N/A',
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : 0.0,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null, // Allow nullable user
    );
  }

  /// Method to convert a [ProductModel] to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'productName': productName,
      'description': description,
      'price': price,
      'sku': sku,
      'productStatus': productStatus,
      'quantityAvailable': quantityAvailable,
      'dimensions': dimensions,
      'warrantyPeriod': warrantyPeriod,
      'weight': weight,
    };

    if (user != null) {
      data['user'] = user!.toJson(); // Include user if not null
    }

    return data;
  }
}
