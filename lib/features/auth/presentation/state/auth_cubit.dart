import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit(this.loginUseCase, this.registerUseCase) : super(AuthState());

  Future<void> login(String username, String password) async {
    emit(AuthState.loading());
    try {
      final token = await loginUseCase.execute(username, password);
      emit(AuthState.success(token));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> register(String username, String email, String password, List<String> roles) async {
    emit(AuthState.loading());
    try {
      final token = await registerUseCase.execute(username, email, password, roles);
      emit(AuthState.success(token));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }
}
