// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';

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
//                             'estado': 'finalizado',
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



// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';
// import 'package:url_launcher/url_launcher.dart'; // Asegúrate de tener este import

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
//     final Uri whatsappUri = Uri.parse("https://wa.me/$phone/?text=${Uri.encodeComponent(message ?? '')}");
//      if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri);
//     } else {
//       _showErrorSnackBar('No se pudo abrir WhatsApp.');
//     }
//   }

//   void _launchEmail(String email, String subject) async {
//     final Uri emailUri = Uri(scheme: 'mailto', path: email, query: 'subject=${Uri.encodeComponent(subject)}');
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//        _showErrorSnackBar('No se pudo abrir la app de correo.');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message, style: GoogleFonts.poppins()),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   void _showRatingDialog(BuildContext context, SolicitudModel solicitud) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return BlocProvider.value(
//           value: BlocProvider.of<SolicitudBloc>(context),
//           child: RatingDialog(solicitud: solicitud),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF56A3A6);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           'Mis Solicitudes',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//       ),
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (context) => SolicitudBloc()),
//         ],
//         child: MultiBlocListener(
//           listeners: [
//             BlocListener<ProfileBloc, ProfileState>(
//               listener: (context, profileState) {
//                 if (profileState is ProfileLoaded && profileState.user != null) {
//                   context.read<SolicitudBloc>().add(
//                         GetSolicitudesByClientEvent(profileState.user!.id!),
//                       );
//                 } else if (profileState is ProfileError) {
//                   _showErrorSnackBar('Error al cargar el perfil.');
//                 }
//               },
//             ),
//             BlocListener<SolicitudBloc, SolicitudState>(
//               listener: (context, state) {
//                 if (state is SolicitudUpdateSuccess) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('¡Gracias por calificar el servicio!', style: GoogleFonts.poppins()),
//                       backgroundColor: Colors.green,
//                       behavior: SnackBarBehavior.floating,
//                     ),
//                   );
//                   final profileState = context.read<ProfileBloc>().state;
//                   if (profileState is ProfileLoaded && profileState.user != null) {
//                     context.read<SolicitudBloc>().add(
//                           GetSolicitudesByClientEvent(profileState.user!.id!),
//                         );
//                   }
//                 } else if (state is SolicitudError) {
//                   _showErrorSnackBar('Ocurrió un error: ');
//                 }
//               },
//             ),
//           ],
//           child: BlocBuilder<SolicitudBloc, SolicitudState>(
//             builder: (context, solicitudState) {
//               if (solicitudState is SolicitudesByClientLoading || solicitudState is SolicitudInitial) {
//                 return const Center(child: CircularProgressIndicator(color: primaryColor));
//               }

//               if (solicitudState is SolicitudesByClientLoaded) {
//                 if (solicitudState.solicitudes.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No tienes solicitudes',
//                           style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return RefreshIndicator(
//                   onRefresh: () async {
//                      final profileState = context.read<ProfileBloc>().state;
//                       if (profileState is ProfileLoaded && profileState.user != null) {
//                         context.read<SolicitudBloc>().add(GetSolicitudesByClientEvent(profileState.user!.id!));
//                       }
//                   },
//                   color: primaryColor,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: solicitudState.solicitudes.length,
//                     itemBuilder: (context, index) {
//                       final solicitud = solicitudState.solicitudes[index];
//                       return SolicitudCard(
//                         solicitud: solicitud,
//                         onContactEmail: () => _launchEmail(solicitud.tecnico!.usuario.correo!, solicitud.titulo),
//                         onContactWhatsApp: () => _launchWhatsApp(solicitud.tecnico!.usuario.telefono!, "Hola, te contacto por la solicitud: ${solicitud.titulo}"),
//                         onFinish: () => _showRatingDialog(context, solicitud),
//                       );
//                     },
//                   ),
//                 );
//               }

//               if (solicitudState is SolicitudError) {
//                  return Center(child: Text('Error al cargar solicitudes:'));
//               }
              
//               return const Center(child: Text('Cargando...'));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


// // --- WIDGETS PERSONALIZADOS PARA ESTA VISTA ---

// // 1. TARJETA DE SOLICITUD REDISEÑADA
// class SolicitudCard extends StatelessWidget {
//   final SolicitudModel solicitud;
//   final VoidCallback onContactWhatsApp;
//   final VoidCallback onContactEmail;
//   final VoidCallback onFinish;

//   const SolicitudCard({
//     super.key,
//     required this.solicitud,
//     required this.onContactWhatsApp,
//     required this.onContactEmail,
//     required this.onFinish,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF56A3A6);
//     final bool isAccepted = solicitud.estado.toUpperCase() == 'ACEPTADO';
//     final bool isFinished = solicitud.estado.toUpperCase() == 'FINALIZADO';
//     final tecnico = solicitud.tecnico;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       shadowColor: Colors.black.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     solicitud.titulo,
//                     style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 17),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 StatusBadge(status: solicitud.estado),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Divider(),
//             const SizedBox(height: 8),

//             if (tecnico != null)
//               InfoRow(
//                 icon: Icons.person_outline,
//                 label: 'Técnico:',
//                 value: '${tecnico.usuario.firstName} ${tecnico.usuario.lastName}',
//               ),

//             InfoRow(
//               icon: Icons.calendar_today_outlined,
//               label: 'Fecha:',
//               value: solicitud.toString().split(' ')[0],
//             ),
            
//             if (isFinished) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                    Text('Calificación:', style: GoogleFonts.poppins(color: Colors.grey[700])),
//                    const SizedBox(width: 8),
//                    ...List.generate(5, (starIndex) {
//                       return Icon(
//                         starIndex < (solicitud.calificacion ?? 0) ? Icons.star_rounded : Icons.star_border_rounded,
//                         color: Colors.amber,
//                         size: 20,
//                       );
//                    })
//                 ],
//               )
//             ],

//             if (isAccepted) ...[
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ActionButton(
//                       text: 'Contactar',
//                       icon: FontAwesomeIcons.whatsapp,
//                       color: Colors.green,
//                       onPressed: tecnico?.usuario.telefono != null ? onContactWhatsApp : null,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                    Expanded(
//                     child: ActionButton(
//                       text: 'Correo',
//                       icon: Icons.email_outlined,
//                       color: Colors.orange.shade700,
//                       onPressed: tecnico?.usuario.correo != null ? onContactEmail : null,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: onFinish,
//                   icon: const Icon(Icons.check_circle_outline, size: 18),
//                   label: Text('Finalizar y Calificar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: primaryColor,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 2. WIDGETS AUXILIARES PARA LA TARJETA

// class StatusBadge extends StatelessWidget {
//   final String status;
//   const StatusBadge({super.key, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     Color color;
//     IconData icon;
//     switch (status.toUpperCase()) {
//       case 'ACEPTADO':
//         color = Colors.green;
//         icon = Icons.check_circle_outline;
//         break;
//       case 'FINALIZADO':
//         color = const Color(0xFF56A3A6);
//         icon = Icons.verified_outlined;
//         break;
//       case 'RECHAZADO':
//         color = Colors.red;
//         icon = Icons.cancel_outlined;
//         break;
//       default:
//         color = Colors.orange;
//         icon = Icons.hourglass_empty_outlined;
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 14),
//           const SizedBox(width: 4),
//           Text(status, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   const InfoRow({super.key, required this.icon, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey[600], size: 16),
//           const SizedBox(width: 8),
//           Text(label, style: GoogleFonts.poppins(color: Colors.grey[700])),
//           const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ActionButton extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final Color color;
//   final VoidCallback? onPressed;
  
//   const ActionButton({super.key, required this.text, required this.icon, required this.color, this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       icon: FaIcon(icon, size: 14),
//       label: Text(text),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: onPressed != null ? color : Colors.grey,
//         side: BorderSide(color: onPressed != null ? color : Colors.grey.shade300),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }


// // 3. DIÁLOGO DE CALIFICACIÓN REDISEÑADO
// class RatingDialog extends StatefulWidget {
//   final SolicitudModel solicitud;
//   const RatingDialog({super.key, required this.solicitud});

//   @override
//   State<RatingDialog> createState() => _RatingDialogState();
// }

// class _RatingDialogState extends State<RatingDialog> {
//   int _rating = 0;

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF56A3A6);

//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: Text(
//         'Calificar Servicio',
//         textAlign: TextAlign.center,
//         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '¿Qué tal fue tu experiencia con el servicio?',
//              textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(5, (index) {
//               return IconButton(
//                 onPressed: () => setState(() => _rating = index + 1),
//                 icon: Icon(
//                   index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
//                   color: Colors.amber,
//                   size: 36,
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//       actions: [
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             onPressed: _rating == 0
//                 ? null
//                 : () {
//                     context.read<SolicitudBloc>().add(
//                           UpdateSolicitudEvent(
//                             solicitudId: widget.solicitud.id!,
//                             data: {'estado': 'finalizado', 'calificacion': _rating},
//                           ),
//                         );
//                     Navigator.of(context).pop();
//                   },
//             child: Text('Enviar Calificación', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//           ),
//         ),
//          TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[600]))
//         )
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // ¡Importante!
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final Uri whatsappUri = Uri.parse("https://wa.me/$phone/?text=${Uri.encodeComponent(message ?? '')}");
     if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      _showErrorSnackBar('No se pudo abrir WhatsApp.');
    }
  }

  void _launchEmail(String email, String subject) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email, query: 'subject=${Uri.encodeComponent(subject)}');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
       _showErrorSnackBar('No se pudo abrir la app de correo.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showRatingDialog(BuildContext context, SolicitudModel solicitud) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<SolicitudBloc>(context),
          child: RatingDialog(solicitud: solicitud),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Mis Solicitudes',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SolicitudBloc()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, profileState) {
                if (profileState is ProfileLoaded && profileState.user != null) {
                  context.read<SolicitudBloc>().add(
                        GetSolicitudesByClientEvent(profileState.user!.id!),
                      );
                } else if (profileState is ProfileError) {
                  _showErrorSnackBar('Error al cargar el perfil.');
                }
              },
            ),
            BlocListener<SolicitudBloc, SolicitudState>(
              listener: (context, state) {
                if (state is SolicitudUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡Gracias por calificar el servicio!', style: GoogleFonts.poppins()),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  final profileState = context.read<ProfileBloc>().state;
                  if (profileState is ProfileLoaded && profileState.user != null) {
                    context.read<SolicitudBloc>().add(
                          GetSolicitudesByClientEvent(profileState.user!.id!),
                        );
                  }
                } else if (state is SolicitudError) {
                  _showErrorSnackBar('Ocurrió un error:');
                }
              },
            ),
          ],
          child: BlocBuilder<SolicitudBloc, SolicitudState>(
            builder: (context, solicitudState) {
              if (solicitudState is SolicitudesByClientLoading || solicitudState is SolicitudInitial) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              }

              if (solicitudState is SolicitudesByClientLoaded) {
                if (solicitudState.solicitudes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes solicitudes',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                     final profileState = context.read<ProfileBloc>().state;
                      if (profileState is ProfileLoaded && profileState.user != null) {
                        context.read<SolicitudBloc>().add(GetSolicitudesByClientEvent(profileState.user!.id!));
                      }
                  },
                  color: primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: solicitudState.solicitudes.length,
                    itemBuilder: (context, index) {
                      final solicitud = solicitudState.solicitudes[index];
                      return SolicitudCard(
                        solicitud: solicitud,
                        onContactEmail: () => _launchEmail(solicitud.tecnico!.usuario.correo!, solicitud.titulo),
                        onContactWhatsApp: () => _launchWhatsApp(solicitud.tecnico!.usuario.telefono!, "Hola, te contacto por la solicitud: ${solicitud.titulo}"),
                        onFinish: () => _showRatingDialog(context, solicitud),
                      );
                    },
                  ),
                );
              }

              if (solicitudState is SolicitudError) {
                 return Center(child: Text('Error al cargar solicitudes: '));
              }
              
              return const Center(child: Text('Cargando...'));
            },
          ),
        ),
      ),
    );
  }
}


// --- WIDGETS PERSONALIZADOS PARA ESTA VISTA ---

// 1. TARJETA DE SOLICITUD MEJORADA
class SolicitudCard extends StatelessWidget {
  final SolicitudModel solicitud;
  final VoidCallback onContactWhatsApp;
  final VoidCallback onContactEmail;
  final VoidCallback onFinish;

  const SolicitudCard({
    super.key,
    required this.solicitud,
    required this.onContactWhatsApp,
    required this.onContactEmail,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);
    final bool isAccepted = solicitud.estado.toUpperCase() == 'ACEPTADO';
    final bool isFinished = solicitud.estado.toUpperCase() == 'FINALIZADO';
    final tecnico = solicitud.tecnico;

    return Card(
      // --- INICIO DE CAMBIOS ---
      color: Colors.white, // Color de fondo explícito para contrastar
      elevation: 2, // Se mantiene una elevación sutil
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: Colors.grey.withOpacity(0.2), // Sombra más definida
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // --- FIN DE CAMBIOS ---
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    solicitud.titulo,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusBadge(status: solicitud.estado),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            if (tecnico != null)
              InfoRow(
                icon: Icons.person_outline,
                label: 'Técnico:',
                value: '${tecnico.usuario.firstName} ${tecnico.usuario.lastName}',
              ),

            InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Fecha:',
              value: solicitud.toString().split(' ')[0],
            ),
            
            if (isFinished) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                   Text('Calificación:', style: GoogleFonts.poppins(color: Colors.grey[700])),
                   const SizedBox(width: 8),
                   ...List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < (solicitud.calificacion ?? 0) ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 20,
                      );
                   })
                ],
              )
            ],

            if (isAccepted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      text: 'Contactar',
                      icon: FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      onPressed: tecnico?.usuario.telefono != null ? onContactWhatsApp : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                   Expanded(
                    child: ActionButton(
                      text: 'Correo',
                      icon: Icons.email_outlined,
                      color: Colors.orange.shade700,
                      onPressed: tecnico?.usuario.correo != null ? onContactEmail : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onFinish,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text('Finalizar y Calificar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ... (Los widgets StatusBadge, InfoRow y ActionButton no necesitan cambios)
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status.toUpperCase()) {
      case 'ACEPTADO':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'FINALIZADO':
        color = const Color(0xFF56A3A6);
        icon = Icons.verified_outlined;
        break;
      case 'RECHAZADO':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = Colors.orange;
        icon = Icons.hourglass_empty_outlined;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(status, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 16),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.poppins(color: Colors.grey[700])),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  
  const ActionButton({super.key, required this.text, required this.icon, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, size: 14),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: onPressed != null ? color : Colors.grey,
        side: BorderSide(color: onPressed != null ? color : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}


// 3. DIÁLOGO DE CALIFICACIÓN CORREGIDO Y MEJORADO
class RatingDialog extends StatefulWidget {
  final SolicitudModel solicitud;
  const RatingDialog({super.key, required this.solicitud});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0; // Usar double para el rating bar

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Calificar Servicio',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tu opinión nos ayuda a mejorar.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          // --- INICIO DE CAMBIOS ---
          // Se reemplaza la fila de Iconos por el widget del paquete
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemSize: 30,
            itemBuilder: (context, _) => const Icon(
              Icons.star_rounded,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          // --- FIN DE CAMBIOS ---
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _rating == 0
                ? null
                : () {
                    context.read<SolicitudBloc>().add(
                          UpdateSolicitudEvent(
                            solicitudId: widget.solicitud.id,
                            data: {'estado': 'finalizado', 'calificacion': _rating.toInt()},
                          ),
                        );
                    Navigator.of(context).pop();
                  },
            child: Text('Enviar Calificación', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop()
            , child: Text('Cancelar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))
            ),
          ),
        //  TextButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[600]))
        // )
      ],
    );
  }
}