// import 'package:flutter/material.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';

// class RequestDetails extends StatelessWidget {
//   static String name = '/Rdetails';

//   final SolicitudModel requestData;

//   const RequestDetails({super.key, required this.requestData});
//   // final Map<String, String> requestData;

//   // const RequestDetails({super.key, required this.requestData});

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
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20.0),
//                 decoration: BoxDecoration(
//                   color: const Color(
//                     0xFFE0F2F7,
//                   ), // Color de fondo de la tarjeta
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           requestData.titulo, //
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF424242),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(
//                               context,
//                             ).pop(); // Cierra la vista de detalles
//                           },
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.red,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(height: 20, thickness: 1, color: Colors.grey),
//                     _buildInfoRow(
//                       'Descripción:',
//                       requestData.descripcion ?? 'No disponible',
//                     ), //
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Fotos:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF424242),
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildPhotoPlaceholder(),
//                         const SizedBox(width: 10),
//                         _buildPhotoPlaceholder(),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _buildInfoRow('Cliente:', requestData.cliente.firstName!),
//                     _buildInfoRow('Categoría:', requestData.categoria.nombre!),
//                     // _buildInfoRow('Distrito:', requestData.!), //
//                     _buildInfoRow('Dirección:', requestData.direccion), 
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Botones de Aceptar y Rechazar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Lógica para Aceptar la solicitud
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               'Solicitud ${requestData.titulo} Aceptada',
//                             ),
//                           ),
//                         );
//                         Navigator.of(
//                           context,
//                         ).pop(); // Vuelve a la vista anterior
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             AppColors.primary, // Color verde para Aceptar
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         elevation: 3,
//                       ),
//                       child: const Text(
//                         'Aceptar', //
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Lógica para Rechazar la solicitud
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               'Solicitud ${requestData.titulo} Rechazada',
//                             ),
//                           ),
//                         );
//                         Navigator.of(
//                           context,
//                         ).pop(); // Vuelve a la vista anterior
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             Colors.red[600], // Color rojo para Rechazar
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         elevation: 3,
//                       ),
//                       child: const Text(
//                         'Rechazar', //
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

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

//   Widget _buildPhotoPlaceholder() {
//     // Puedes reemplazar esto con Image.network o Image.file
//     // Si tienes URLs de imágenes en requestData, úsalas aquí.
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//         image: const DecorationImage(
//           image: AssetImage(
//             'assets/placeholder_key.png',
//           ), // Reemplaza con tu imagen si la tienes
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: const Icon(
//         Icons.image,
//         color: Colors.grey,
//         size: 50,
//       ), // Icono de placeholder si no hay imagen
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';

class RequestDetails extends StatelessWidget {
  static String name = '/Rdetails';

  final SolicitudModel requestData;

  const RequestDetails({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle de la Solicitud',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
            fontFamily: 'PatuaOne',
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // 1. Envolvemos el cuerpo en un BlocConsumer para escuchar estados y reconstruir la UI
      body: BlocConsumer<SolicitudBloc, SolicitudState>(
        // 2. El 'listener' reacciona a los cambios de estado para acciones como mostrar SnackBars o navegar.
        listener: (context, state) {
          if (state is SolicitudUpdateSuccess) {
            // Si la actualización fue exitosa, muestra un mensaje y cierra la pantalla.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Solicitud "${state.solicitudActualizada.titulo}" fue actualizada a: ${state.solicitudActualizada.estado}'),
                backgroundColor: Colors.green,
              ),
            );
            // Cierra la vista de detalles y vuelve a la lista.
            // Enviamos 'true' para indicar a la pantalla anterior que debe refrescar los datos.
            Navigator.of(context).pop(true); 
          } 
          // else if (state is SolicitudError) {
          //   // Si hubo un error, muestra el mensaje de error.
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('Error: ${state.message}'),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
          // }
        },
        // 3. El 'builder' reconstruye la UI. Lo usamos para mostrar un estado de carga en los botones.
        builder: (context, state) {
          // Variable para saber si estamos en medio de una actualización.
          final bool isLoading = state is SolicitudUpdating;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F7),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... (El resto de tu UI de detalles se mantiene igual)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                requestData.titulo,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF424242),
                                ),
                              ),
                              // He eliminado el botón de cerrar porque el AppBar ya tiene uno de 'atrás'
                            ]),
                        const Divider(height: 20, thickness: 1, color: Colors.grey),
                         _buildInfoRow(
                           'Descripción:',
                           requestData.descripcion ?? 'No disponible',
                         ),
                         const SizedBox(height: 10),
                         const Text(
                           'Fotos:',
                           style: TextStyle(
                             fontSize: 16,
                             color: Color(0xFF424242),
                             fontWeight: FontWeight.normal,
                           ),
                         ),
                         const SizedBox(height: 8),
                         Row(
                           children: [
                             _buildPhotoPlaceholder(),
                             const SizedBox(width: 10),
                             _buildPhotoPlaceholder(),
                           ],
                         ),
                         const SizedBox(height: 20),
                         _buildInfoRow('Cliente:', requestData.cliente.firstName ?? 'N/A'),
                         _buildInfoRow('Categoría:', requestData.categoria.nombre ?? 'N/A'),
                         _buildInfoRow('Dirección:', requestData.direccion ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botones de Aceptar y Rechazar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // Si está cargando, onPressed es null para deshabilitar el botón.
                          onPressed: isLoading
                              ? null
                              : () {
                                  // 4. Disparar el evento para ACEPTAR la solicitud
                                  context.read<SolicitudBloc>().add(
                                        UpdateSolicitudEvent(
                                          solicitudId: requestData.id,
                                          data: {'estado': 'aceptado'},
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 3,
                          ),
                          // Si está cargando, muestra un indicador, si no, el texto.
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Aceptar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          // Deshabilitar si está cargando
                          onPressed: isLoading
                              ? null
                              : () {
                                  // 4. Disparar el evento para RECHAZAR la solicitud
                                  context.read<SolicitudBloc>().add(
                                        UpdateSolicitudEvent(
                                          solicitudId: requestData.id,
                                          data: {'estado': 'rechazado'},
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 3,
                          ),
                          // Mostrar indicador de carga
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Rechazar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
        return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text.rich(
        TextSpan(
          text: '$label ',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/Tools.png',
          ), 
          fit: BoxFit.cover,
        ),
      ),
      child: const Icon(
        Icons.image,
        color: Colors.grey,
        size: 50,
      ), // Icono de placeholder si no hay imagen
    );
  }
}