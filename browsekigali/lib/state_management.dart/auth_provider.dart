import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> signup(String email, String password, String name) async {
    _user = await _authService.signUp(
      email: email,
      password: password,
      name: name,
    );
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _user = await _authService.login(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}