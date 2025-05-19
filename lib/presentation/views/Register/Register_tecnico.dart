import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import '../../widgets/Widgets.dart';

class RegisterTecnico extends StatefulWidget {
  const RegisterTecnico({super.key});
  static String name = '/RTecnico';

  @override
  State<RegisterTecnico> createState() => _RegisterTecnicoState();
}

class _RegisterTecnicoState extends State<RegisterTecnico> {
  final List<String> categorias = [
    'Cerrajero',
    'Electrónico',
    'Electricista',
    'Técnico',
    'Gasfitería',
    'Mecánico',
  ];

  final List<String> seleccionadas = [];

  void toggleCategoria(String categoria) {
    setState(() {
      if (seleccionadas.contains(categoria)) {
        seleccionadas.remove(categoria);
      } else {
        if (seleccionadas.length < 3) {
          seleccionadas.add(categoria);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solo puedes seleccionar hasta 3 categorías'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Técnico',
          style: TextStyle(fontFamily: 'PatuaOne'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(label: 'Nombres', hintText: 'Ingresar nombres'),
            CustomTextField(label: 'Apellidos', hintText: 'Ingresar apellidos'),
            CustomTextField(label: 'Usuario', hintText: 'Ingresar usuario'),
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
            const SizedBox(height: 16),
            const Text(
              'Agregar los distritos de atención',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child: const Text('Agregar'),
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dirección',
              hintText: 'Ingresar dirección de domicilio',
            ),
            const SizedBox(height: 16),
            CustomTextField(label: 'Fecha de nacimiento', hintText: 'dd/mm/aa'),
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
                const SizedBox(width: 10),
                const Text('Seleccionar'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Seleccione máximo 3 categorías',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children:
                  categorias.map((categoria) {
                    return CategoriaSelector(
                      nombre: categoria,
                      estaSeleccionado: seleccionadas.contains(categoria),
                      onTap: () => toggleCategoria(categoria),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/login_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
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
