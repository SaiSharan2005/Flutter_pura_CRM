// lib/features/customer/presentation/pages/customer_list_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';

// Domain and Use Case imports
import '../../domain/entities/customer_entity.dart';
import '../../domain/usecases/get_all_customers.dart';

// Data Layer imports
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';

// Define your primary color.
const primaryColor = Color(0xFFE41B47);

class CustomerListPage extends StatelessWidget {
  final String baseUrl;

  const CustomerListPage({Key? key, required this.baseUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create an instance of ApiClient using the baseUrl and http.Client.
    final client = http.Client();
    final apiClient = ApiClient(baseUrl, client);
    final remoteDataSource = CustomerRemoteDataSourceImpl(apiClient: apiClient);
    final repository =
        CustomerRepositoryImpl(remoteDataSource: remoteDataSource);
    final getAllCustomersUseCase = GetAllCustomers(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Detail",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/customer/create');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: getAllCustomersUseCase.call(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final customers = snapshot.data;
          if (customers == null || customers.isEmpty) {
            return const Center(child: Text("No customers found"));
          }
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              // Use a fallback if the customer name is empty.
              final avatarLetter = customer.customerName.isNotEmpty
                  ? customer.customerName[0].toUpperCase()
                  : '?';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Text(
                      avatarLetter,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(customer.customerName),
                  subtitle: Text(customer.email),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: primaryColor),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/customer/detail',
                      arguments: customer.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/customer/create');
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
