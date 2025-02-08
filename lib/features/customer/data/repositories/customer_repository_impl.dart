// import 'package:pura_crm/features/customer/data/datasources/customer_remote_data_source.dart';
// import 'package:pura_crm/features/customer/data/models/customer_model.dart';
// import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
// import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';

// class CustomerRepositoryImpl implements CustomerRepository {
//   final CustomerRemoteDataSource remoteDataSource;

//   CustomerRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Customer> createCustomer(Customer customer) async {
//     final customerModel = CustomerModel(
//       id: customer.id,
//       customerName: customer.customerName,
//       email: customer.email,
//       phoneNumber: customer.phoneNumber,
//       address: customer.address,
//       noOfOrders: customer.noOfOrders,
//       buyerCompanyName: customer.buyerCompanyName,
//     );
//     return await remoteDataSource.createCustomer(customerModel);
//   }

//   @override
//   Future<void> deleteCustomerById(int id) async {
//     return await remoteDataSource.deleteCustomerById(id);
//   }

//   @override
//   Future<List<Customer>> getAllCustomers() async {
//     return await remoteDataSource.getAllCustomers();
//   }

//   @override
//   Future<Customer> getCustomerById(int id) async {
//     return await remoteDataSource.getCustomerById(id);
//   }

//   @override
//   Future<Customer> updateCustomerById(int id, Customer customer) async {
//     final customerModel = CustomerModel(
//       id: customer.id,
//       customerName: customer.customerName,
//       email: customer.email,
//       phoneNumber: customer.phoneNumber,
//       address: customer.address,
//       noOfOrders: customer.noOfOrders,
//       buyerCompanyName: customer.buyerCompanyName,
//     );
//     return await remoteDataSource.updateCustomerById(id, customerModel);
//   }
// }
