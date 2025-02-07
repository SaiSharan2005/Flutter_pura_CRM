import 'package:pura_crm/features/products/domain/entities/cartItem_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double totalPrice;
  
  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'price': price,
        'totalPrice': totalPrice,
      };

  // Convert CartItemModel to CartItemEntity (domain entity)
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
    );
  }

  // Copy method to create a new instance with the same or overridden properties.
  CartItemModel copy({
    int? id,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    double? totalPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
