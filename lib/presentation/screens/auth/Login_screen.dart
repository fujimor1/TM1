import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Login/Login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static String name = 'login_screen';

  @override
  Widget build(BuildContext context) {
    return LoginView();
  }
}