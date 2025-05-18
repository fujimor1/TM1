import 'package:flutter/material.dart';
import 'package:tm1/presentation/widgets/CampoEditable.dart';
import 'package:tm1/presentation/widgets/DatosPerfil.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 2),
      appBar: AppBar(
        title: Text(
          'Datos Socio Ayuda Pe',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.logout, color: Colors.black),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DatoPerfil(label: 'Nombres', value: 'Luciana Ysabel'),
                DatoPerfil(
                  label: 'Apellidos',
                  value: 'Vasquez Falcón',
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DatoPerfil(label: 'N° DNI', value: '12345678'),
                DatoPerfil(
                  label: 'Fecha de Nacimiento',
                  value: '07/04/2011',
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Datos de Contacto',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            const CampoEditable(
              label: 'Nombre de usuario',
              initialValue: 'luciana1234',
            ),
            const CampoEditable(
              label: 'Teléfono de contacto',
              initialValue: '123456789',
            ),
            const CampoEditable(
              label: 'Correo electrónico',
              initialValue: 'luciana1234@gmail.com',
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5FB7B7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Guardar Datos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
