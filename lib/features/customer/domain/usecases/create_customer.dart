import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';

class CreateCustomer {
  final CustomerRepository repository;

  CreateCustomer(this.repository);

  Future<Customer> call(Customer customer) {
    return repository.createCustomer(customer);
  }
}
