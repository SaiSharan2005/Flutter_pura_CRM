abstract class AuthRepository {
  Future<String> register(String username, String email, String password, List<String> roles);
  Future<String> login(String username, String password);
}
