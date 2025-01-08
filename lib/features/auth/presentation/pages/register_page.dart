import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/models/error_response.dart';
import 'package:pura_crm/features/auth/presentation/pages/login_page.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

class RegisterPage extends StatefulWidget {
  final RemoteDataSource remoteDataSource;

  const RegisterPage({Key? key, required this.remoteDataSource}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _roles = ['SALESMAN'];

  bool _isLoading = false;
  ErrorResponse? _errorMessage;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        String token = await widget.remoteDataSource.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _roles,
        );

        SecureStorageHelper.saveToken(token);
        SnackBarUtils.showSuccessSnackBar(context, 'Registration successful!');
        // Navigate after registration if required
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
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      //   backgroundColor: const Color(0xFFE41B47),
      // ),
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
              // const SizedBox(height: 32),

              const Text(
                'Create an Account',
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
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFE41B47)),
                  labelText: 'Email',
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
                    return 'Please enter an email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _roles.first,
                items: ['MANAGER', 'DELIVERY', 'SALESMAN']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person, // Example icon
                        color: Color(0xFFE41B47),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_outline, // Icon for the dropdown
                    color: Color(0xFFE41B47),
                  ),
                  labelText: 'Role',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE41B47), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                iconSize: 24,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _roles[0] = value;
                    });
                  }
                },
                menuMaxHeight: 200, // Adjusted for smaller dropdown
              ),

              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE41B47),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(remoteDataSource: widget.remoteDataSource), // Pass remoteDataSource correctly
                      ),
                    );
                  },
                  child: Text(
                    'Already have an account? Login',
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
