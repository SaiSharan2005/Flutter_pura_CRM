import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';

class DeleteCustomer {
  final CustomerRepository repository;

  DeleteCustomer(this.repository);

  Future<void> call(int id) {
    return repository.deleteCustomerById(id);
  }
}
