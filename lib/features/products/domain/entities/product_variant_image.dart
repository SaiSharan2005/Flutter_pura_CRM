import 'package:equatable/equatable.dart';

class ProductVariantImage extends Equatable {
  final int? id;

  final String imageUrl;

  const ProductVariantImage({
    this.id,
    required this.imageUrl,
  });

  factory ProductVariantImage.fromJson(Map<String, dynamic> json) {
    return ProductVariantImage(
      id: json['id'] as int?,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, imageUrl];
}
