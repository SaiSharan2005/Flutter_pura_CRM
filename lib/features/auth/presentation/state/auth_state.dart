class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;

  AuthState({this.isLoading = false, this.token, this.error});

  factory AuthState.loading() => AuthState(isLoading: true);

  factory AuthState.success(String token) => AuthState(token: token);

  factory AuthState.error(String error) => AuthState(error: error);
}
