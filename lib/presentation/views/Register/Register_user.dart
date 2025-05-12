import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';

class RegisterUser extends StatelessWidget {
  const RegisterUser({super.key});

  static String name = '/RUser';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario', style: TextStyle(fontFamily: 'PatuaOne')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
              label: 'Nombres',
              hintText: 'Ingresar nombres',
            ),
            CustomTextField(
              label: 'Apellidos',
              hintText: 'Ingresar apellidos',
            ),
            CustomTextField(
              label: 'Usuario',
              hintText: 'Ingresar usuario',
            ),
            CustomTextField(
              label: 'Contraseña',
              hintText: 'Ingresar contraseña',
              obscureText: true,
              suffixIcon: const Icon(Icons.visibility),
            ),
            CustomTextField(
              label: 'Repetir contraseña',
              hintText: 'Repetir contraseña',
              obscureText: true,
              suffixIcon: const Icon(Icons.visibility),
            ),
            CustomTextField(
              label: 'DNI',
              hintText: 'Ingresar documento de identidad',
            ),
            CustomTextField(
              label: 'Correo electrónico',
              hintText: 'Ingresar correo electrónico',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/login_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Crear cuenta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
