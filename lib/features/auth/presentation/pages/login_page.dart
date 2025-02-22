import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/models/error_response.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
import 'package:pura_crm/utils/snack_bar_utils.dart';

class LoginPage extends StatefulWidget {
  final RemoteDataSource remoteDataSource;

  const LoginPage({super.key, required this.remoteDataSource});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoAnimation;

  bool _isLoading = false;
  ErrorResponse? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        SecureStorageHelper.deleteToken();
        String token = await widget.remoteDataSource.login(
          _usernameController.text,
          _passwordController.text,
        );
        await SecureStorageHelper.saveToken(token);
        UserDTO user = await widget.remoteDataSource.me();
        SecureStorageHelper.saveUserData(user);

        SnackBarUtils.showSuccessSnackBar(context, 'Login successful!');
        Navigator.pushNamed(context, '/salesmanHome');
      } catch (error) {
        setState(() {
          _errorMessage = ErrorResponse(message: error.toString());
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE41B47), Color(0xFFFF6A84)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SlideTransition(
                position: _slideAnimation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ScaleTransition(
                            scale: _logoAnimation,
                            child: Center(
                              child: Image.asset(
                                'assets/logo.png',
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE41B47),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFFE41B47)),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a username'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xFFE41B47)),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
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
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() {});
                              },
                              onTapUp: (_) => _login(),
                              child: AnimatedScale(
                                scale: _isLoading ? 0.9 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE41B47),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationPage(
                                      remoteDataSource: widget.remoteDataSource,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Don\'t have an account? Register',
                                style: TextStyle(
                                  color: Color(0xFFE41B47),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
