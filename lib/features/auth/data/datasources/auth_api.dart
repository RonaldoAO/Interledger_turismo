import 'dart:async';
import '../../domain/entities/user.dart';

class AuthApi {
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (password == '123456') {
      return User(id: 'u_1', email: email);
    }
    throw Exception('Credenciales inválidas');
  }
}

