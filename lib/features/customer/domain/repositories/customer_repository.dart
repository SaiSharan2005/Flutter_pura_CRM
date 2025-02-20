import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<Customer> createCustomer(Customer customer);
  Future<List<Customer>> getAllCustomers();
  Future<Customer> getCustomerById(int id);
  Future<Customer> updateCustomerById(int id, Customer customer);
  Future<void> deleteCustomerById(int id);
}
