import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/repositories/salesman_repository_impl.dart';
import 'package:pura_crm/features/auth/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/auth/presentation/pages/login_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
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
    remoteDataSource = RemoteDataSource(apiClient); // Initialize here
    salesmanRepository = SalesmanRepositoryImpl(apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesmanProvider(salesmanRepository),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => HomePage(),
          '/salesman': (context) => SalesmanCreatePage(),
          '/signup': (context) => RegisterPage(remoteDataSource: remoteDataSource),
          '/login': (context) => LoginPage(remoteDataSource: remoteDataSource),
        },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup'); // Navigate to Signup page
              },
              child: Text('Signup'),
            ),
            SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to Login page
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
