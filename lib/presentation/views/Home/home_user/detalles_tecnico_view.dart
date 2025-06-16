import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class DetalleTecnicoView extends StatelessWidget {
  final TecnicoModel tecnico;
  final String categoria;
  final String distrito;
  final int categoryId;

  static const String name = '/DetallesTecnico';

  const DetalleTecnicoView({super.key, required this.tecnico, required this.categoria, required this.distrito,  required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final String tecnicoNombreCompleto = '${tecnico.usuario.firstName ?? ''} ${tecnico.usuario.lastName ?? ''}'.trim();
    final String tecnicoUsername = tecnico.usuario.username ?? 'Técnico Desconocido';
    final String descripcionTecnico = 'Técnico especialista en ${tecnico.categorias.isNotEmpty ? (tecnico.categorias.first.nombre ?? 'servicios') : 'varios servicios'}. ${tecnicoUsername} ofrece soluciones rápidas y eficientes.';
    print('Id de tecnico seleccionado: ${tecnico.usuario.id}');
    print('Id de la categoria DTV seleccionado: ${categoryId}');


    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
      appBar: AppBar(
        title: Text(
          categoria.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'PatuaOne',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              distrito,
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ),
          const Padding(
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
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: CachedNetworkImage( // Usar CachedNetworkImage para mejor manejo de caché y errores
                  //     imageUrl: imageUrl,
                  //     width: 180,
                  //     height: 180,
                  //     fit: BoxFit.cover,
                  //     placeholder: (context, url) => const CircularProgressIndicator(), // Mientras carga
                  //     errorWidget: (context, url, error) => Image.asset( // Imagen de error si falla la carga
                  //       'assets/images/placeholder_profile.png', // Asegúrate de tener una imagen de placeholder en assets
                  //       width: 180,
                  //       height: 180,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Text(
                    tecnicoNombreCompleto.isNotEmpty
                        ? tecnicoNombreCompleto
                        : tecnicoUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    descripcionTecnico, // Usar la descripción generada/obtenida
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < (tecnico.calificacion ?? 0).round()
                            ? Icons.star
                            : Icons.star_border, // Calificación
                        size: 20,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Asumo que 'assets/images/Contaco.png' es una imagen local relevante
            Image.asset('assets/images/Contaco.png', height: 130),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5FB7B7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // print('Categoría: $primeraCategoriaNombre');
                // print('Distrito: $primerDistritoNombre');
                context.pushNamed(
                  '/Solicitud',
                  extra: {
                    'categoria': categoria,
                    'distrito': distrito,
                    'categoryId': categoryId,
                    'tecnicoId': tecnico.usuario.id
                  },
                );
              },
              child: const Text(
                'Solicitar servicio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
