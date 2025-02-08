// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pura_crm/features/customer/data/datasources/customer_remote_data_source.dart';
// import 'package:pura_crm/features/customer/data/repositories/customer_repository_impl.dart';
// import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
// import 'package:pura_crm/features/customer/domain/usecases/get_all_customers.dart';

// class CustomerPage extends StatelessWidget {
//   final String baseUrl;

//   const CustomerPage({Key? key, required this.baseUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Setup dependencies for the customer module:
//     final client = http.Client();
//     final remoteDataSource =
//         CustomerRemoteDataSource(client: client, baseUrl: baseUrl);
//     final repository =
//         CustomerRepositoryImpl(remoteDataSource: remoteDataSource);
//     final getAllCustomersUseCase = GetAllCustomers(repository);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Customers"),
//       ),
//       body: FutureBuilder<List<Customer>>(
//         future: getAllCustomersUseCase.call(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           final customers = snapshot.data;
//           if (customers == null || customers.isEmpty) {
//             return Center(child: Text("No customers found"));
//           }
//           return ListView.builder(
//             itemCount: customers.length,
//             itemBuilder: (context, index) {
//               final customer = customers[index];
//               return ListTile(
//                 title: Text(customer.customerName),
//                 subtitle: Text(customer.email),
//                 onTap: () {
//                   // Navigate to details page, if needed.
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
