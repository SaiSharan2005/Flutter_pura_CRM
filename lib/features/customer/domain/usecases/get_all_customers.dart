import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';

class GetAllCustomers {
  final CustomerRepository repository;

  GetAllCustomers(this.repository);

  Future<List<Customer>> call() {
    return repository.getAllCustomers();
  }
}
