import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getAllProducts();
  }
}

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductById(id);
  }
}

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<void> call(Product product) async {
    await repository.createProduct(product);
  }
}

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<void> call(int id, Product product) async {
    await repository.updateProduct(id, product);
  }
}

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteProduct(id);
  }
}
