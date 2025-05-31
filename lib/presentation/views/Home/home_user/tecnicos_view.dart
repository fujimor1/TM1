import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class TecnicosView extends StatefulWidget {
  static const String name = '/TecnicosView';

  final String categoria;

  const TecnicosView({super.key, required this.categoria});

  @override
  State<TecnicosView> createState() => _TecnicosViewState();
}

class _TecnicosViewState extends State<TecnicosView> {
  String? distritoSeleccionado;

  final List<String> distritos = [
    'Villa el Salvador',
    'San Juan de Miraflores',
    'Chorrillos',
  ];

  final List<Map<String, dynamic>> tecnicos = [
    {
      'nombre': 'Rebeca Perez',
      'categoria': 'Electricista',
      'distrito': 'Villa el Salvador',
      'rating': 5,
      'imagen': 'https://randomuser.me/api/portraits/women/1.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
    {
      'nombre': 'Pedro Vega',
      'categoria': 'Cerrajero',
      'distrito': 'Villa el Salvador',
      'rating': 4,
      'imagen': 'https://randomuser.me/api/portraits/men/2.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
    {
      'nombre': 'Miguel Coronado',
      'categoria': 'Cerrajero',
      'distrito': 'San Juan de Miraflores',
      'rating': 5,
      'imagen': 'https://randomuser.me/api/portraits/men/3.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
    {
      'nombre': 'Sandra Condori',
      'categoria': 'Cerrajero',
      'distrito': 'Chorrillos',
      'rating': 4,
      'imagen': 'https://randomuser.me/api/portraits/women/4.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
    {
      'nombre': 'Alberto Ferreyro',
      'categoria': 'Cerrajero',
      'distrito': 'Villa el Salvador',
      'rating': 2,
      'imagen': 'https://randomuser.me/api/portraits/men/5.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
    {
      'nombre': 'Marco Ramos',
      'categoria': 'Cerrajero',
      'distrito': 'San Juan de Miraflores',
      'rating': 3,
      'imagen': 'https://randomuser.me/api/portraits/men/6.jpg',
      'descripcion': 'Experiencia en instalación, mantenimiento y reparación de cerraduras, candados y sistemas de seguridad.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtrados = tecnicos.where((t) {
      final coincideCategoria = t['categoria'] == widget.categoria;
      final coincideDistrito = distritoSeleccionado == null || t['distrito'] == distritoSeleccionado;
      return coincideCategoria && coincideDistrito;
    }).toList();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.categoria.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              distritoSeleccionado ?? 'Todos los distritos',
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.location_on),
            onSelected: (value) {
              setState(() {
                distritoSeleccionado = value;
              });
            },
            itemBuilder: (context) {
              return distritos.map((d) {
                return PopupMenuItem(
                  value: d,
                  child: Text(d),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: filtrados.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final tecnico = filtrados[index];
            final nombre = tecnico['nombre'] as String;
            final rating = tecnico['rating'] as int;
            final imagen = tecnico['imagen'] as String;

            return InkWell(
              onTap: () {
                context.pushNamed('/DetallesTecnico',
                extra: tecnico
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade200, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imagen,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
