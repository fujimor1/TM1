import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';

class RegisterTecnico extends StatelessWidget {
  const RegisterTecnico({super.key});

  static String name = '/RTecnico';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Técnico', style: TextStyle(fontFamily: 'PatuaOne')),
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
            const SizedBox(height: 24),

            const Text(
              'Agregar los distritos de atención',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null, // Solo UI
                    child: const Text('Agregar'),
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //   margin: const EdgeInsets.only(bottom: 10),
            //   decoration: BoxDecoration(
            //     color: Colors.teal.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Colors.teal),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       Text(
            //         'San Juan de Miraflores',
            //         style: TextStyle(
            //           color: Colors.teal,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       Icon(Icons.close, color: Colors.red),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dirección',
              hintText: 'Ingresar dirección de domicilio',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Fecha de nacimiento',
              hintText: 'dd/mm/aa',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Correo electrónico',
              hintText: 'Ingresar correo electrónico',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Teléfono',
              hintText: 'Ingresar número de celular',
            ),
            const SizedBox(height: 16),
            const Text(
              'Foto de perfil',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Image.asset('assets/images/Contaco.png'),
                Center(
                  child: Text('Seleccionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/login_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
