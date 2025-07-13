// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/data/model/tecnico/tecnico_model.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class DetalleTecnicoView extends StatelessWidget {
//   final TecnicoModel tecnico;
//   final String categoria;
//   final String distrito;
//   final int categoryId;

//   static const String name = '/DetallesTecnico';

//   const DetalleTecnicoView({super.key, required this.tecnico, required this.categoria, required this.distrito,  required this.categoryId});

//   @override
//   Widget build(BuildContext context) {
//     final String tecnicoNombreCompleto = '${tecnico.usuario.firstName ?? ''} ${tecnico.usuario.lastName ?? ''}'.trim();
//     final String tecnicoUsername = tecnico.usuario.username ?? 'Técnico Desconocido';
//     final String descripcionTecnico = 'Técnico especialista en ${tecnico.categorias.isNotEmpty ? (tecnico.categorias.first.nombre ?? 'servicios') : 'varios servicios'}. ${tecnicoUsername} ofrece soluciones rápidas y eficientes.';
//     print('Id de tecnico seleccionado: ${tecnico.usuario.id}');
//     print('Id de la categoria DTV seleccionado: ${categoryId}');


//     return Scaffold(
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
//       appBar: AppBar(
//         title: Text(
//           categoria.toUpperCase(),
//           style: const TextStyle(
//             fontFamily: 'PatuaOne',
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Text(
//               distrito,
//               style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(10),
//             child: Icon(Icons.location_on),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE2F2D9),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // ClipRRect(
//                   //   borderRadius: BorderRadius.circular(12),
//                   //   child: CachedNetworkImage( // Usar CachedNetworkImage para mejor manejo de caché y errores
//                   //     imageUrl: imageUrl,
//                   //     width: 180,
//                   //     height: 180,
//                   //     fit: BoxFit.cover,
//                   //     placeholder: (context, url) => const CircularProgressIndicator(), // Mientras carga
//                   //     errorWidget: (context, url, error) => Image.asset( // Imagen de error si falla la carga
//                   //       'assets/images/placeholder_profile.png', // Asegúrate de tener una imagen de placeholder en assets
//                   //       width: 180,
//                   //       height: 180,
//                   //       fit: BoxFit.cover,
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 10),
//                   Text(
//                     tecnicoNombreCompleto.isNotEmpty
//                         ? tecnicoNombreCompleto
//                         : tecnicoUsername,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     descripcionTecnico, // Usar la descripción generada/obtenida
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       5,
//                       (i) => Icon(
//                         i < (tecnico.calificacion ?? 0).round()
//                             ? Icons.star
//                             : Icons.star_border, // Calificación
//                         size: 20,
//                         color: Colors.amber,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Asumo que 'assets/images/Contaco.png' es una imagen local relevante
//             Image.asset('assets/images/Contaco.png', height: 130),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF5FB7B7),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 // print('Categoría: $primeraCategoriaNombre');
//                 // print('Distrito: $primerDistritoNombre');
//                 context.pushNamed(
//                   '/Solicitud',
//                   extra: {
//                     'categoria': categoria,
//                     'distrito': distrito,
//                     'categoryId': categoryId,
//                     'tecnicoId': tecnico.usuario.id
//                   },
//                 );
//               },
//               child: const Text(
//                 'Solicitar servicio',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class DetalleTecnicoView extends StatelessWidget {
  final TecnicoModel tecnico;
  final String categoria;
  final String distrito;
  final int categoryId;

  static const String name = '/DetallesTecnico';

  const DetalleTecnicoView({
    super.key,
    required this.tecnico,
    required this.categoria,
    required this.distrito,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);
    const String baseUrl = 'https://res.cloudinary.com/delww5upv/';
    
    final String tecnicoNombreCompleto = '${tecnico.usuario.firstName ?? ''} ${tecnico.usuario.lastName ?? ''}'.trim();
    final String descripcionTecnico = 'Técnico especialista en ${tecnico.categorias.isNotEmpty ? (tecnico.categorias.first.nombre ?? 'servicios') : 'varios servicios'}. Ofrezco soluciones rápidas y eficientes para tus necesidades.';

    String imageUrl = tecnico.fotoPerfil ?? '';
    if (!imageUrl.startsWith('http')) {
      imageUrl = '$baseUrl$imageUrl';
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Se elimina el bottomNavigationBar para dar más espacio y centrarse en la acción principal.
      // Si es indispensable, puedes volver a añadirlo aquí.
      body: Stack(
        children: [
          // Contenido principal que se puede desplazar
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, imageUrl, tecnicoNombreCompleto),
                _buildContent(context, descripcionTecnico),
                const SizedBox(height: 100), // Espacio para el botón flotante
              ],
            ),
          ),
          // AppBar transparente superpuesto
          _buildAppBar(context),
          // Botón de acción fijo en la parte inferior
          _buildFixedActionButton(context, primaryColor),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String imageUrl, String nombre) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Fondo del encabezado
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF56A3A6),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        // Foto de perfil
        Positioned(
          bottom: -100, // La mitad de la altura total del contenido del perfil
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(imageUrl),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey[200],
                  child: tecnico.fotoPerfil == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                nombre,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              RatingBarIndicator(
                rating: tecnico.calificacion?.toDouble() ?? 0.0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 24.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, String descripcion) {
    return Padding(
      padding: const EdgeInsets.only(top: 120, left: 16, right: 16), // Espacio para el header
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Acerca de mí',
            child: Text(
              descripcion,
              style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Detalles',
            child: Column(
              children: [
                DetailRow(
                  icon: Icons.category_outlined,
                  label: 'Categoría',
                  value: categoria,
                ),
                const Divider(height: 24),
                DetailRow(
                  icon: Icons.map_outlined,
                  label: 'Distrito de cobertura',
                  value: distrito,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFixedActionButton(BuildContext context, Color color) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: color.withOpacity(0.4),
            ),
            onPressed: () {
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
            child: Text(
              'Solicitar Servicio',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// WIDGET AUXILIAR PARA LAS FILAS DE DETALLES
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        )
      ],
    );
  }
}