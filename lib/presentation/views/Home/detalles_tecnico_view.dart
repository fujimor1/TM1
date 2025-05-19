import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class DetalleTecnicoView extends StatelessWidget {

  static const String name = '/DetallesTecnico';

  final String nombre;
  final String imagenUrl;
  final String descripcion;
  final String categoria;
  final String distrito;

  const DetalleTecnicoView({
    super.key,
    required this.nombre,
    required this.imagenUrl,
    required this.descripcion,
    required this.categoria, 
    required this.distrito,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      appBar: AppBar(
        title: Text(
          categoria.toUpperCase(),
          style: TextStyle(
            fontFamily: 'PatuaOne',
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.location_on),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2F2D9),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imagenUrl,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(descripcion, textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/Contaco.png', height: 130),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5FB7B7),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.pushNamed('/Solicitud',
                extra: {
                  'categoria': categoria,
                  'distrito': distrito,
                }
                );
              },
              child: const Text('Solicitar servicio', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
