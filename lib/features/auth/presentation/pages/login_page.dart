import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/models/error_response.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

class LoginPage extends StatefulWidget {
  final RemoteDataSource remoteDataSource;

  const LoginPage({Key? key, required this.remoteDataSource}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  ErrorResponse? _errorMessage;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        String token = await widget.remoteDataSource.login(
          _usernameController.text,
          _passwordController.text,
        );

        SecureStorageHelper.saveToken(token);
        SnackBarUtils.showSuccessSnackBar(context, 'Login successful!');
        // Navigate to the next page after successful login
      } catch (error) {
        setState(() {
          if (error is Map<String, dynamic>) {
            _errorMessage = ErrorResponse.fromJson(error);
          } else {
            _errorMessage = ErrorResponse(message: error.toString());
          }
        });

        SnackBarUtils.showErrorSnackBar(
          context,
          _errorMessage?.message ?? 'Unknown error occurred',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png', // Replace with your image path
                  height: 150, // Adjust height as needed
                  width: 150,  // Adjust width as needed
                ),
              ),
              const Text(
                'Login to Your Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFE41B47)),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE41B47)),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFE41B47)),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE41B47)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE41B47),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(remoteDataSource: widget.remoteDataSource), // Pass remoteDataSource to RegisterPage
                      ),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
