import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final User? user;
  final String? error;
  const AuthState({this.loading = false, this.user, this.error});

  AuthState copyWith({bool? loading, User? user, String? error}) => AuthState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        error: error,
      );
}

final authApiProvider = Provider<AuthApi>((ref) => AuthApi());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authApiProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  AuthController(this.loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await loginUseCase(email, password);
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final login = ref.read(loginUseCaseProvider);
  return AuthController(login);
});
