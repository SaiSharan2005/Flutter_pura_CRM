import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> register(String username, String email, String password, List<String> roles) async {
    final token = await remoteDataSource.register(username, email, password, roles);
    await SecureStorageHelper.saveToken(token);
    return token;
  }

  @override
  Future<String> login(String username, String password) async {
    final token = await remoteDataSource.login(username, password);
    await SecureStorageHelper.saveToken(token);
    return token;
  }
}
