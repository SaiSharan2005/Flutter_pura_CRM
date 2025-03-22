import 'package:equatable/equatable.dart';
import 'product_variant.dart';

class Product extends Equatable {
  final int? id;
  final String productName;
  final String description;
  final String productStatus;
  final DateTime createdDate;
  final List<ProductVariant> variants;

  const Product({
    this.id,
    required this.productName,
    required this.description,
    required this.productStatus,
    required this.createdDate,
    required this.variants,
  });

  @override
  List<Object?> get props =>
      [id, productName, description, productStatus, createdDate, variants];
}
