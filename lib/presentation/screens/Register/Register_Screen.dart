import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Register/register_view.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static String name = '/Register';

  @override
  Widget build(BuildContext context) {
    return RegisterView();
  }
}