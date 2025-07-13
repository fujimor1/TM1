// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';

// class RequestDetails extends StatelessWidget {
//   static String name = '/Rdetails';

//   final SolicitudModel requestData;

//   const RequestDetails({super.key, required this.requestData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Detalle de la Solicitud',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF424242),
//             fontFamily: 'PatuaOne',
//           ),
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       // Usamos BlocConsumer para escuchar estados y reconstruir la UI
//       body: BlocConsumer<SolicitudBloc, SolicitudState>(
//         // El 'listener' reacciona a los cambios de estado para acciones como mostrar SnackBars o navegar.
//         listener: (context, state) {
//           if (state is SolicitudUpdateSuccess) {
//             // Si la actualización fue exitosa, muestra un mensaje y cierra la pantalla.
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Solicitud "${state.solicitudActualizada.titulo}" fue actualizada a: ${state.solicitudActualizada.estado}',
//                 ),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             // Cierra la vista de detalles y vuelve a la lista.
//             // Enviamos 'true' para indicar a la pantalla anterior que debe refrescar los datos.
//             Navigator.of(context).pop(true);
//           } else if (state is SolicitudError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Ocurrió un error al actualizar la solicitud.'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         // El 'builder' reconstruye la UI. Lo usamos para mostrar un estado de carga en los botones.
//         builder: (context, state) {
//           // Variable para saber si estamos en medio de una actualización.
//           final bool isLoading = state is SolicitudUpdating;

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE0F2F7),
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded( // Usamos Expanded para evitar overflow si el título es largo
//                               child: Text(
//                                 requestData.titulo,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF424242),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           height: 20,
//                           thickness: 1,
//                           color: Colors.grey,
//                         ),
//                         _buildInfoRow(
//                           'Descripción:',
//                           requestData.descripcion,
//                         ),
//                         const SizedBox(height: 10),
                        
//                         const Text(
//                           'Fotos:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Color(0xFF424242),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         // Aquí se llama al método que construye la galería de fotos
//                         _buildPhotosSection(),
//                         const SizedBox(height: 20),
//                         _buildInfoRow(
//                           'Cliente:',
//                           requestData.cliente.firstName ?? 'N/A',
//                         ),
//                         _buildInfoRow(
//                           'Categoría:',
//                           requestData.categoria.nombre!,
//                         ),
//                         _buildInfoRow(
//                           'Dirección:',
//                           requestData.direccion,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Botones de Aceptar y Rechazar
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: isLoading
//                               ? null
//                               : () {
//                                   context.read<SolicitudBloc>().add(
//                                         UpdateSolicitudEvent(
//                                           solicitudId: requestData.id,
//                                           data: {'estado': 'aceptado'},
//                                         ),
//                                       );
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             elevation: 3,
//                           ),
//                           child: isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Aceptar',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: isLoading
//                               ? null
//                               : () {
//                                   context.read<SolicitudBloc>().add(
//                                         UpdateSolicitudEvent(
//                                           solicitudId: requestData.id,
//                                           data: {'estado': 'cancelado'},
//                                         ),
//                                       );
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red[600],
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             elevation: 3,
//                           ),
//                           child: isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Text(
//                                   'Rechazar',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// Método auxiliar para construir la sección de la galería de fotos.
//   Widget _buildPhotosSection() {
//     // --- IMPORTANTE: REEMPLAZA ESTO CON TU "CLOUD NAME" DE CLOUDINARY ---
//     const String cloudinaryBaseUrl = "https://res.cloudinary.com/delww5upv/";
//     // --------------------------------------------------------------------

//     // Verificamos si la lista de fotos está vacía
//     if (requestData.fotosSolicitud.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.0),
//         child: Text(
//           'No hay fotos adjuntas.',
//           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
//         ),
//       );
//     }

//     // Si hay fotos, construimos una lista horizontal
//     return SizedBox(
//       height: 100, // Altura fija para la galería
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal, // Hacemos que se desplace horizontalmente
//         itemCount: requestData.fotosSolicitud.length,
//         itemBuilder: (context, index) {
//           final foto = requestData.fotosSolicitud[index];
//           // Validamos que la URL no sea nula o vacía
//           if (foto.urlFoto == null || foto.urlFoto!.isEmpty) {
//             return _buildPhotoErrorPlaceholder(); // Muestra un placeholder de error si la URL está vacía
//           }

//           // Construimos la URL completa para la imagen
//           final String fullImageUrl = cloudinaryBaseUrl + foto.urlFoto!;

//           return Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               // Usamos Image.network para cargar la imagen desde la URL completa
//               child: Image.network(
//                 fullImageUrl,
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.cover,
//                 // Muestra un indicador de carga mientras la imagen descarga
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     width: 100,
//                     height: 100,
//                     color: Colors.grey[200],
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     ),
//                   );
//                 },
//                 // Muestra un widget de error si la imagen no se puede cargar
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildPhotoErrorPlaceholder();
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// Método auxiliar para construir una fila de información (label: value).
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Text.rich(
//         TextSpan(
//           text: '$label ',
//           style: const TextStyle(
//             fontSize: 16,
//             color: Color(0xFF424242),
//             fontWeight: FontWeight.normal,
//           ),
//           children: [
//             TextSpan(
//               text: value,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Método auxiliar para mostrar un placeholder cuando una imagen no carga.
//   Widget _buildPhotoErrorPlaceholder() {
//     return Container(
//       width: 100,
//       height: 100,
//       margin: const EdgeInsets.only(right: 10.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(
//         Icons.broken_image_outlined,
//         color: Colors.grey,
//         size: 40,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';

class RequestDetails extends StatelessWidget {
  static String name = '/Rdetails';

  final SolicitudModel requestData;

  const RequestDetails({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Detalle de Solicitud', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<SolicitudBloc, SolicitudState>(
        listener: (context, state) {
          if (state is SolicitudUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('La solicitud fue actualizada a: ${state.solicitudActualizada.estado}'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.of(context).pop(true); // Vuelve y refresca
          } else if (state is SolicitudError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar: '),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is SolicitudUpdating;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildDetailCard(context),
                      const SizedBox(height: 16),
                      _buildDescriptionCard(context),
                      const SizedBox(height: 16),
                      _buildPhotosCard(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Barra de acción fija en la parte inferior
              _buildActionButtons(context, isLoading, primaryColor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return _buildInfoCard(
      title: requestData.titulo,
      children: [
        _InfoRow(icon: Icons.person_outline, label: 'Cliente', value: requestData.cliente.firstName ?? 'N/A'),
        _InfoRow(icon: Icons.category_outlined, label: 'Categoría', value: requestData.categoria.nombre ?? 'N/A'),
        _InfoRow(icon: Icons.location_on_outlined, label: 'Dirección', value: requestData.direccion),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return _buildInfoCard(
      title: 'Descripción del Problema',
      children: [
        Text(
          requestData.descripcion,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPhotosCard(BuildContext context) {
    return _buildInfoCard(
      title: 'Fotos Adjuntas',
      children: [
        if (requestData.fotosSolicitud.isEmpty)
          Text('No hay fotos adjuntas.', style: GoogleFonts.poppins(color: Colors.grey, fontStyle: FontStyle.italic))
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: requestData.fotosSolicitud.length,
              itemBuilder: (context, index) {
                const String cloudinaryBaseUrl = "https://res.cloudinary.com/delww5upv/";
                final foto = requestData.fotosSolicitud[index];
                if (foto.urlFoto == null || foto.urlFoto!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final String fullImageUrl = cloudinaryBaseUrl + foto.urlFoto!;

                return GestureDetector(
                  onTap: () {
                    // Navega a la vista de pantalla completa
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(imageUrl: fullImageUrl),
                    ));
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(fullImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isLoading, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : () {
                context.read<SolicitudBloc>().add(
                      UpdateSolicitudEvent(solicitudId: requestData.id, data: {'estado': 'rechazado'}),
                    );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: isLoading ? Colors.grey.shade300 : Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox.shrink() // No mostrar nada si el otro botón está cargando
                  : Text('Rechazar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading ? null : () {
                context.read<SolicitudBloc>().add(
                      UpdateSolicitudEvent(solicitudId: requestData.id, data: {'estado': 'aceptado'}),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text('Aceptar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black87)),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA ADICIONAL PARA VER IMAGEN EN PANTALLA COMPLETA ---

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer( // Permite hacer zoom y pan
          panEnabled: false,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}