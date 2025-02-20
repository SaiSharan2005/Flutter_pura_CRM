import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';

class Product extends Equatable {
  final int? id;
  final String productName;
  final String description;
  final double price;
  final String sku;
  final String productStatus;
  final int quantityAvailable;
  final String dimensions;
  final int warrantyPeriod;
  final double weight;
  final User? user;

  const Product({
    this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.sku,
    required this.productStatus,
    required this.quantityAvailable,
    required this.dimensions,
    required this.warrantyPeriod,
    required this.weight,
    this.user,
  });

  @override
  List<Object?> get props => [
        id,
        productName,
        description,
        price,
        sku,
        productStatus,
        quantityAvailable,
        dimensions,
        warrantyPeriod,
        weight,
        user
      ];
}
