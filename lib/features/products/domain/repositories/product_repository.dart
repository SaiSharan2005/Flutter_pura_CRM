import 'package:pura_crm/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductById(int id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(int id, Product product);
  Future<void> deleteProduct(int id);
}
