import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart'; // Update with your file structure

void main() {
  // Initialize dependencies
  final apiClient = ApiClient('http://localhost:8005/api', http.Client());
  final remoteDataSource = RemoteDataSource(apiClient);

  runApp(MyApp(remoteDataSource: remoteDataSource));
}

class MyApp extends StatelessWidget {
  final RemoteDataSource remoteDataSource;

  const MyApp({Key? key, required this.remoteDataSource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pura CRM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(remoteDataSource: remoteDataSource),
      debugShowCheckedModeBanner: false,
    );
  }
}
