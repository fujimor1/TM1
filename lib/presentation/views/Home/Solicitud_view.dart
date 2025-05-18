import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class SolicitudServicioView extends StatelessWidget {

  static const String name = '/Solicitud';

  final String categoria;
  final String distrito;

  const SolicitudServicioView({
    super.key,
    required this.categoria,
    required this.distrito,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      appBar: AppBar(title: const Text('SOLICITUD DE SERVICIO')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Título del problema',
              hintText: 'Ej. Llave atorada',
            ),
            CustomTextField(
              label: 'Categoría',
              hintText: categoria,
              enabled: false,
            ),
            CustomTextField(
              label: 'Distrito',
              hintText: distrito,
              enabled: false,
            ),
            CustomTextField(
              label: 'Dirección',
              hintText: 'Mz. M St. 3 Gr. 11',
            ),
            CustomTextField(
              label: 'Descripción del problema',
              hintText: 'Se rompió mi llave y se quedó dentro de la cerradura.',
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8),
            const Text(
              'Adjuntar fotos (las que usted considere necesarias)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Seleccionar imágenes de su dispositivo',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/Home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5FB7B7),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Enviar solicitud',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
