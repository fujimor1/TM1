// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';
// import 'package:url_launcher/url_launcher.dart'; // Importar el paquete

// class RequestView extends StatefulWidget {
//   static const String name = '/requests';

//   const RequestView({super.key});

//   @override
//   State<RequestView> createState() => _RequestViewState();
// }

// class _RequestViewState extends State<RequestView> {
//   @override
//   void initState() {
//     super.initState();
//     // Se asegura de obtener el perfil del usuario al iniciar la vista.
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//   }

//   // --- INICIO DE CAMBIOS ---
//   // Función para lanzar WhatsApp
//   void _launchWhatsApp(String phone, String? message) async {
//     // Asegúrate que el número de teléfono tenga el código del país, ej: +51 para Perú
//     final String whatsappUrl = "https://wa.me/$phone?text=${Uri.encodeComponent(message ?? 'Hola, te contacto por una solicitud.')}";
//     final Uri whatsappUri = Uri.parse(whatsappUrl);

//     if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
//     } else {
//       // Muestra un error si no se puede abrir WhatsApp
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No se pudo abrir WhatsApp para el número: $phone')),
//       );
//     }
//   }

//   // Función para lanzar el cliente de Email
//   void _launchEmail(String email, String subject) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent('Hola, te contacto acerca de la solicitud: "$subject"')}',
//     );

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//        // Muestra un error si no se puede abrir el cliente de correo
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No se pudo abrir el cliente de correo para: $email')),
//       );
//     }
//   }
//   // --- FIN DE CAMBIOS ---

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (context) => SolicitudBloc())],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'MIS SOLICITUDES',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontFamily: 'PatuaOne',
//             ),
//           ),
//           centerTitle: true,
//         ),
//         bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: BlocListener<ProfileBloc, ProfileState>(
//             listener: (context, profileState) {
//               if (profileState is ProfileLoaded && profileState.user != null) {
//                 context.read<SolicitudBloc>().add(
//                       GetSolicitudesByClientEvent(profileState.user!.id!),
//                     );
//               } else if (profileState is ProfileError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       'Error al cargar los datos del usuario para sus solicitudes.',
//                     ),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: BlocBuilder<SolicitudBloc, SolicitudState>(
//               builder: (context, solicitudState) {
//                 if (solicitudState is SolicitudesByClientLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (solicitudState is SolicitudesByClientLoaded) {
//                   if (solicitudState.solicitudes.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No tienes solicitudes registradas.',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     );
//                   }
//                   return ListView.builder(
//                     itemCount: solicitudState.solicitudes.length,
//                     itemBuilder: (context, index) {
//                       final SolicitudModel solicitud =
//                           solicitudState.solicitudes[index];
//                       final String estado = solicitud.estado;
//                       final String titulo = solicitud.titulo;
                      
//                       // --- INICIO DE CAMBIOS ---
//                       // Extraer teléfono y correo del técnico (usando null-safety)
//                       final String? telefonoTecnico = solicitud.tecnico?.usuario.telefono;
//                       final String? correoTecnico = solicitud.tecnico?.usuario.correo;
//                       // --- FIN DE CAMBIOS ---

//                       return SolicitudCard(
//                         onClose: () {
//                           print(
//                             'Intentando eliminar solicitud: ${solicitud.id}',
//                           );
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               titulo,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             RichText(
//                               text: TextSpan(
//                                 style: const TextStyle(color: Colors.black87),
//                                 children: [
//                                   const TextSpan(text: 'Estado: '),
//                                   TextSpan(
//                                     text: estado,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (estado.toUpperCase() == 'ACEPTADO') ...[
//                               const SizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   // --- INICIO DE CAMBIOS ---
//                                   _buildContactButton(
//                                     icon: FontAwesomeIcons.whatsapp,
//                                     text: 'Contactar',
//                                     color: Colors.green,
//                                     onPressed: telefonoTecnico != null 
//                                       ? () => _launchWhatsApp(telefonoTecnico, 'Hola, te contacto por la solicitud: "$titulo"')
//                                       : null, // Deshabilitar si no hay teléfono
//                                   ),
//                                   const SizedBox(width: 12),
//                                   _buildContactButton(
//                                     icon: FontAwesomeIcons.solidEnvelope,
//                                     text: 'Contactar',
//                                     color: Colors.red,
//                                      onPressed: correoTecnico != null
//                                       ? () => _launchEmail(correoTecnico, titulo)
//                                       : null, // Deshabilitar si no hay correo
//                                   ),
//                                   // --- FIN DE CAMBIOS ---
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               Center(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.brown,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     print(
//                                       'Marcando solicitud ${solicitud.id} como FINALIZADA',
//                                     );
//                                   },
//                                   child: const Text(
//                                     'FINALIZADO',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 } else if (solicitudState is SolicitudError) {
//                   // Muestra el mensaje de error del estado
//                   return Center(
//                     child: Text(
//                       'Error al cargar solicitudes:',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   );
//                 }
//                 return const Center(child: Text('Cargando solicitudes...'));
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactButton({
//     required IconData icon,
//     required String text,
//     required Color color,
//     VoidCallback? onPressed,
//   }) {
//     // --- INICIO DE CAMBIOS ---
//     // Se usa 'InkWell' para el efecto visual y se controla el estado deshabilitado
//     bool isEnabled = onPressed != null;
//     return Expanded(
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           decoration: BoxDecoration(
//             color: isEnabled ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: isEnabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3))
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FaIcon(icon, color: isEnabled ? color : Colors.grey, size: 16),
//               const SizedBox(width: 8),
//               Text(text, style: TextStyle(color: isEnabled ? color : Colors.grey, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//     // --- FIN DE CAMBIOS ---
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class RequestView extends StatefulWidget {
//   static const String name = '/requests';

//   const RequestView({super.key});

//   @override
//   State<RequestView> createState() => _RequestViewState();
// }

// class _RequestViewState extends State<RequestView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//   }

//   void _launchWhatsApp(String phone, String? message) async {
//     // ... (código sin cambios)
//   }

//   void _launchEmail(String email, String subject) async {
//     // ... (código sin cambios)
//   }

//   // Función para mostrar el diálogo de calificación.
//   void _showRatingDialog(BuildContext context, SolicitudModel solicitud) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         // Se usa BlocProvider.value para pasar la instancia existente del BLoC
//         // al árbol de widgets del diálogo.
//         return BlocProvider.value(
//           value: BlocProvider.of<SolicitudBloc>(context),
//           child: RatingDialog(solicitud: solicitud),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (context) => SolicitudBloc())],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'MIS SOLICITUDES',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontFamily: 'PatuaOne',
//             ),
//           ),
//           centerTitle: true,
//         ),
//         bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           // Se envuelve el BlocBuilder con un MultiBlocListener para reaccionar a los cambios de estado
//           // sin construir la UI de nuevo, como la finalización de una actualización.
//           child: MultiBlocListener(
//             listeners: [
//               BlocListener<ProfileBloc, ProfileState>(
//                 listener: (context, profileState) {
//                   if (profileState is ProfileLoaded && profileState.user != null) {
//                     context.read<SolicitudBloc>().add(
//                           GetSolicitudesByClientEvent(profileState.user!.id!),
//                         );
//                   } else if (profileState is ProfileError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Error al cargar perfil.')),
//                     );
//                   }
//                 },
//               ),
//               BlocListener<SolicitudBloc, SolicitudState>(
//                 listener: (context, state) {
//                   if (state is SolicitudUpdateSuccess) {
//                     // Muestra una confirmación
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('¡Gracias por calificar el servicio!'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     // Vuelve a cargar las solicitudes para refrescar la lista.
//                     // Esto evita modificar la lógica interna del BLoC.
//                     final profileState = context.read<ProfileBloc>().state;
//                     if (profileState is ProfileLoaded && profileState.user != null) {
//                       context.read<SolicitudBloc>().add(
//                             GetSolicitudesByClientEvent(profileState.user!.id!),
//                           );
//                     }
//                   } else if (state is SolicitudError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Ocurrió un error al actualizar la solicitud.'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//             child: BlocBuilder<SolicitudBloc, SolicitudState>(
//               builder: (context, solicitudState) {
//                 if (solicitudState is SolicitudesByClientLoading || solicitudState is SolicitudUpdating) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (solicitudState is SolicitudesByClientLoaded) {
//                   if (solicitudState.solicitudes.isEmpty) {
//                     return const Center(child: Text('No tienes solicitudes registradas.'));
//                   }
//                   return ListView.builder(
//                     itemCount: solicitudState.solicitudes.length,
//                     itemBuilder: (context, index) {
//                       final SolicitudModel solicitud = solicitudState.solicitudes[index];
//                       final String estado = solicitud.estado;
//                       final String titulo = solicitud.titulo;
//                       final String? telefonoTecnico = solicitud.tecnico?.usuario.telefono;
//                       final String? correoTecnico = solicitud.tecnico?.usuario.correo;

//                       return SolicitudCard(
//                         onClose: () {},
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 6),
//                             RichText(
//                               text: TextSpan(
//                                 style: const TextStyle(color: Colors.black87),
//                                 children: [
//                                   const TextSpan(text: 'Estado: '),
//                                   TextSpan(
//                                     text: estado,
//                                     style: const TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Muestra el botón FINALIZADO solo si el estado es ACEPTADO
//                             // y aún no ha sido calificada.
//                             if (estado.toUpperCase() == 'ACEPTADO' && solicitud.calificacion == null) ...[
//                               const SizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   _buildContactButton(
//                                     icon: FontAwesomeIcons.whatsapp,
//                                     text: 'Contactar',
//                                     color: Colors.green,
//                                     onPressed: telefonoTecnico != null
//                                         ? () => _launchWhatsApp(telefonoTecnico, 'Hola, te contacto por la solicitud: "$titulo"')
//                                         : null,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   _buildContactButton(
//                                     icon: FontAwesomeIcons.solidEnvelope,
//                                     text: 'Contactar',
//                                     color: Colors.red,
//                                     onPressed: correoTecnico != null
//                                         ? () => _launchEmail(correoTecnico, titulo)
//                                         : null,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               Center(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.brown,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                   onPressed: () => _showRatingDialog(context, solicitud),
//                                   child: const Text(
//                                     'FINALIZADO',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                             // Si el estado es FINALIZADO, muestra la calificación en su lugar.
//                             if (estado.toUpperCase() == 'FINALIZADO') ...[
//                               const SizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Text('Calificación: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                                   Row(
//                                     children: List.generate(5, (starIndex) {
//                                       return Icon(
//                                         starIndex < (solicitud.calificacion ?? 0) ? Icons.star : Icons.star_border,
//                                         color: Colors.amber,
//                                         size: 20,
//                                       );
//                                     }),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 } else if (solicitudState is SolicitudError) {
//                   return const Center(child: Text('Error al cargar solicitudes.'));
//                 }
//                 return const Center(child: Text('Cargando solicitudes...'));
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContactButton({
//     required IconData icon,
//     required String text,
//     required Color color,
//     VoidCallback? onPressed,
//   }) {
//     bool isEnabled = onPressed != null;
//     return Expanded(
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           decoration: BoxDecoration(
//               color: isEnabled ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: isEnabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FaIcon(icon, color: isEnabled ? color : Colors.grey, size: 16),
//               const SizedBox(width: 8),
//               Text(text, style: TextStyle(color: isEnabled ? color : Colors.grey, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // WIDGET PARA EL DIÁLOGO DE CALIFICACIÓN
// class RatingDialog extends StatefulWidget {
//   final SolicitudModel solicitud;

//   const RatingDialog({super.key, required this.solicitud});

//   @override
//   State<RatingDialog> createState() => _RatingDialogState();
// }

// class _RatingDialogState extends State<RatingDialog> {
//   int _rating = 0; // Almacena la calificación seleccionada localmente

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       backgroundColor: const Color(0xFFE0E8F0), // Un color base azulado claro
//       title: Stack(
//         alignment: Alignment.center,
//         clipBehavior: Clip.none,
//         children: [
//           const Text('CALIFICACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
//           Positioned(
//             top: -14,
//             right: -14,
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: const CircleAvatar(
//                 radius: 14,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.close, color: Colors.red, size: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // --- INICIO DE CAMBIOS ---
//       // Se ajusta el padding del contenido del diálogo para dar más espacio.
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
//       content: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(5, (index) {
//           // Se reemplaza IconButton por GestureDetector para tener control total sobre el tamaño.
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _rating = index + 1;
//               });
//             },
//             // Se añade un padding para dar espacio entre las estrellas y aumentar el área de toque.
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Icon(
//                 index < _rating ? Icons.star : Icons.star_border,
//                 color: Colors.amber,
//                 size: 32,
//               ),
//             ),
//           );
//         }),
//       ),
//       // --- FIN DE CAMBIOS ---
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2E8B57), // Verde mar
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//           ),
//           onPressed: _rating == 0
//               ? null
//               : () {
//                   context.read<SolicitudBloc>().add(
//                         UpdateSolicitudEvent(
//                           solicitudId: widget.solicitud.id!,
//                           data: {
//                             'estado': 'FINALIZADO',
//                             'calificacion': _rating,
//                           },
//                         ),
//                       );
//                   Navigator.of(context).pop();
//                 },
//           child: const Text('ENVIAR'),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestView extends StatefulWidget {
  static const String name = '/requests';

  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  void _launchWhatsApp(String phone, String? message) async {
    // ... (código sin cambios)
  }

  void _launchEmail(String email, String subject) async {
    // ... (código sin cambios)
  }

  // Función para mostrar el diálogo de calificación.
  void _showRatingDialog(BuildContext context, SolicitudModel solicitud) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Se usa BlocProvider.value para pasar la instancia existente del BLoC
        // al árbol de widgets del diálogo.
        return BlocProvider.value(
          value: BlocProvider.of<SolicitudBloc>(context),
          child: RatingDialog(solicitud: solicitud),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SolicitudBloc())],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MIS SOLICITUDES',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'PatuaOne',
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
        body: Padding(
          padding: const EdgeInsets.all(16),
          // Se envuelve el BlocBuilder con un MultiBlocListener para reaccionar a los cambios de estado
          // sin construir la UI de nuevo, como la finalización de una actualización.
          child: MultiBlocListener(
            listeners: [
              BlocListener<ProfileBloc, ProfileState>(
                listener: (context, profileState) {
                  if (profileState is ProfileLoaded && profileState.user != null) {
                    context.read<SolicitudBloc>().add(
                          GetSolicitudesByClientEvent(profileState.user!.id!),
                        );
                  } else if (profileState is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al cargar perfil.')),
                    );
                  }
                },
              ),
              BlocListener<SolicitudBloc, SolicitudState>(
                listener: (context, state) {
                  if (state is SolicitudUpdateSuccess) {
                    // Muestra una confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Gracias por calificar el servicio!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Vuelve a cargar las solicitudes para refrescar la lista.
                    // Esto evita modificar la lógica interna del BLoC.
                    final profileState = context.read<ProfileBloc>().state;
                    if (profileState is ProfileLoaded && profileState.user != null) {
                      context.read<SolicitudBloc>().add(
                            GetSolicitudesByClientEvent(profileState.user!.id!),
                          );
                    }
                  } else if (state is SolicitudError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ocurrió un error al actualizar la solicitud.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<SolicitudBloc, SolicitudState>(
              builder: (context, solicitudState) {
                if (solicitudState is SolicitudesByClientLoading || solicitudState is SolicitudUpdating) {
                  return const Center(child: CircularProgressIndicator());
                } else if (solicitudState is SolicitudesByClientLoaded) {
                  if (solicitudState.solicitudes.isEmpty) {
                    return const Center(child: Text('No tienes solicitudes registradas.'));
                  }
                  return ListView.builder(
                    itemCount: solicitudState.solicitudes.length,
                    itemBuilder: (context, index) {
                      final SolicitudModel solicitud = solicitudState.solicitudes[index];
                      final String estado = solicitud.estado;
                      final String titulo = solicitud.titulo;
                      final String? telefonoTecnico = solicitud.tecnico?.usuario.telefono;
                      final String? correoTecnico = solicitud.tecnico?.usuario.correo;

                      return SolicitudCard(
                        onClose: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87),
                                children: [
                                  const TextSpan(text: 'Estado: '),
                                  TextSpan(
                                    text: estado,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            // Muestra el botón FINALIZADO solo si el estado es ACEPTADO
                            // y aún no ha sido calificada.
                            if (estado.toUpperCase() == 'ACEPTADO' && solicitud.calificacion == null) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildContactButton(
                                    icon: FontAwesomeIcons.whatsapp,
                                    text: 'Contactar',
                                    color: Colors.green,
                                    onPressed: telefonoTecnico != null
                                        ? () => _launchWhatsApp(telefonoTecnico, 'Hola, te contacto por la solicitud: "$titulo"')
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildContactButton(
                                    icon: FontAwesomeIcons.solidEnvelope,
                                    text: 'Contactar',
                                    color: Colors.red,
                                    onPressed: correoTecnico != null
                                        ? () => _launchEmail(correoTecnico, titulo)
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => _showRatingDialog(context, solicitud),
                                  child: const Text(
                                    'FINALIZADO',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                            // Si el estado es FINALIZADO, muestra la calificación en su lugar.
                            if (estado.toUpperCase() == 'FINALIZADO') ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Calificación: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < (solicitud.calificacion ?? 0) ? Icons.star : Icons.star_border,
                                        color: Colors.amber,
                                        size: 20,
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                } else if (solicitudState is SolicitudError) {
                  return const Center(child: Text('Error al cargar solicitudes.'));
                }
                return const Center(child: Text('Cargando solicitudes...'));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onPressed,
  }) {
    bool isEnabled = onPressed != null;
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
              color: isEnabled ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isEnabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: isEnabled ? color : Colors.grey, size: 16),
              const SizedBox(width: 8),
              Text(text, style: TextStyle(color: isEnabled ? color : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET PARA EL DIÁLOGO DE CALIFICACIÓN
class RatingDialog extends StatefulWidget {
  final SolicitudModel solicitud;

  const RatingDialog({super.key, required this.solicitud});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0; // Almacena la calificación seleccionada localmente

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xFFE0E8F0), // Un color base azulado claro
      title: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Text('CALIFICACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
          Positioned(
            top: -14,
            right: -14,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Colors.red, size: 18),
              ),
            ),
          ),
        ],
      ),
      // --- INICIO DE CAMBIOS ---
      // Se ajusta el padding del contenido del diálogo para dar más espacio.
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          // Se reemplaza IconButton por GestureDetector para tener control total sobre el tamaño.
          return GestureDetector(
            onTap: () {
              setState(() {
                _rating = index + 1;
              });
            },
            // Se añade un padding para dar espacio entre las estrellas y aumentar el área de toque.
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
            ),
          );
        }),
      ),
      // --- FIN DE CAMBIOS ---
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E8B57), // Verde mar
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          onPressed: _rating == 0
              ? null
              : () {
                  context.read<SolicitudBloc>().add(
                        UpdateSolicitudEvent(
                          solicitudId: widget.solicitud.id!,
                          data: {
                            'estado': 'finalizado',
                            'calificacion': _rating,
                          },
                        ),
                      );
                  Navigator.of(context).pop();
                },
          child: const Text('ENVIAR'),
        ),
      ],
    );
  }
}
