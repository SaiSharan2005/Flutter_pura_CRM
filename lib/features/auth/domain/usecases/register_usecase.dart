// register_usecase.dart
import 'package:pura_crm/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<String> execute(String username, String email, String password, List<String> roles) {
    return repository.register(username, email, password, roles);
  }
}
