import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/data/models/product_model.dart';

class CartItemModel {
  final int id;
  final ProductModel product;
  final int quantity;
  final double price;
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // JSON deserialization
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      product:
          ProductModel.fromJson(json['product'] ?? {}), // Deserialize product
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(), // Serialize product
        'quantity': quantity,
        'price': price,
        'totalPrice': totalPrice,
      };

  // Convert CartItemModel to CartItemEntity (domain entity)
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      product: product, // Pass ProductModel correctly
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
    );
  }

  // Copy method to create a new instance with the same or overridden properties.
  CartItemModel copy({
    int? id,
    ProductModel? product,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product, // Copying product correctly
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
