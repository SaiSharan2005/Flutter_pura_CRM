
// login_usecase.dart
import 'package:pura_crm/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> execute(String username, String password) {
    return repository.login(username, password);
  }
}
