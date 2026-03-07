import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import '../state_management.dart/auth_provider.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoggedIn) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
