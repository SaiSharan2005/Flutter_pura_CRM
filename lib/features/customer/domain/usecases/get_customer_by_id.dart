import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';

class GetCustomerById {
  final CustomerRepository repository;

  GetCustomerById(this.repository);

  Future<Customer> call(int id) {
    return repository.getCustomerById(id);
  }
}
