import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class ProfileViewTecnico extends StatefulWidget {
  const ProfileViewTecnico({super.key});

  static String name = '/Ptecnico';

  @override
  State<ProfileViewTecnico> createState() => _ProfileViewTecnicoState();
}

class _ProfileViewTecnicoState extends State<ProfileViewTecnico> {
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
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 3),
      appBar: AppBar(
        title: const Text(
          'Datos Socio Chambea Ya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
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
      body: ListView(
        children: [
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DatoPerfil(label: 'Nombres', value: 'Camila Ysabel'),
                DatoPerfil(label: 'Apellidos', value: 'Vega Ramos'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                DatoPerfil(label: 'N° DNI', value: '12345678'),
                DatoPerfil(label: 'Fecha de Nacimiento', value: '07/04/2011'),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Datos de Contacto',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            const CampoEditable(label: 'Nombre de usuario', initialValue: 'luciana1234'),
            const CampoEditable(label: 'Teléfono de contacto', initialValue: '123456789'),
            const CampoEditable(label: 'Correo electrónico', initialValue: 'luciana1234@gmail.com'),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Aquí puedes manejar la lógica de guardar datos
                },
                child: const Text(
                  'Guardar Datos',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
          ],
        ),
      ),
        ],
      )
    );
  }
}
