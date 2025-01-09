import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/repositories/salesman_repository_impl.dart';
import 'package:pura_crm/features/auth/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/auth/presentation/pages/salesman_page.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiClient = ApiClient('http://localhost:8005/api', http.Client());
  late final RemoteDataSource remoteDataSource;
  late final SalesmanRepository salesmanRepository;

  MyApp() {
    // remoteDataSource = RemoteDataSource(apiClient);
    salesmanRepository = SalesmanRepositoryImpl(apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesmanProvider(salesmanRepository), // Pass dependency here
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => HomePage(),
          '/salesman': (context) => SalesmanCreatePage(),
        },
        initialRoute: '/',
      ),
    );
  }
}

// Example HomePage widget
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(child: Text('Welcome to the Home Page!')),
    );
  }
}
