// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/solicitud/solicitud_model.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

// class RequestViewTecnico extends StatefulWidget {
//   static const String name = '/RVtecnico';

//   const RequestViewTecnico({super.key});

//   @override
//   State<RequestViewTecnico> createState() => _RequestViewTecnicoState();
// }

// class _RequestViewTecnicoState extends State<RequestViewTecnico> {
//   String _selectedEstado = 'Todas';
//   String _selectedCategoria = 'Todas';

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => SolicitudBloc()),
//         BlocProvider(create: (context) => TecnicoBloc()),
//       ],
//       child: Scaffold(
//         bottomNavigationBar: const Custombottomnavigationbartecnico(
//           currentIndex: 1,
//         ),
//         appBar: AppBar(
//           title: const Text(
//             'MIS SOLICITUDES',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF424242),
//               fontFamily: 'PatuaOne',
//             ),
//           ),
//           centerTitle: true,
//         ),
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildFilterButton(
//                   'Estado',
//                   _selectedEstado,
//                   ['Todas', 'pendiente', 'aceptado', 'rechazado', 'Finalizado'],
//                   (value) {
//                     setState(() {
//                       _selectedEstado = value;
//                       _filterRequests(context);
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 20),
//                 BlocBuilder<TecnicoBloc, TecnicoState>(
//                   builder: (context, tecnicoState) {
//                     List<String> categorias = ['Todas'];
//                     if (tecnicoState is TecnicoLoaded) {
//                       categorias.addAll(
//                         tecnicoState.tecnico.categorias.map((c) => c.nombre!),
//                       );
//                     }
//                     return _buildFilterButton(
//                       'Categoría',
//                       _selectedCategoria,
//                       categorias,
//                       (value) {
//                         setState(() {
//                           _selectedCategoria = value;
//                           _filterRequests(context);
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Expanded(
//               child: BlocListener<ProfileBloc, ProfileState>(
//                 listener: (context, profileState) {
//                   if (profileState is ProfileLoaded &&
//                       profileState.user != null) {
//                     final tecnicoId = profileState.user!.id!;
//                     print('Profile Loaded for Tecnico - User ID: $tecnicoId');

//                     // Solicitudes del técnico
//                     context.read<SolicitudBloc>().add(
//                       GetSolicitudesByTecnicoEvent(tecnicoId),
//                     );

//                     context.read<TecnicoBloc>().add(
//                       GetTecnicoByIdEvent(tecnicoId),
//                     );
//                   } else if (profileState is ProfileError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           'Error al cargar los datos del técnico para sus solicitudes.',
//                         ),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//                 child: BlocBuilder<SolicitudBloc, SolicitudState>(
//                   builder: (context, solicitudState) {
//                     if (solicitudState is SolicitudesByTecnicoLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (solicitudState is SolicitudesByTecnicoLoaded) {
//                       final List<SolicitudModel> filteredRequests =
//                           _filterSolicitudes(solicitudState.solicitudes);

//                       if (filteredRequests.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No tienes solicitudes asignadas con los filtros seleccionados.',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         );
//                       }
//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         itemCount: filteredRequests.length,
//                         itemBuilder: (context, index) {
//                           final SolicitudModel request =
//                               filteredRequests[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 20.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (request.estado.toLowerCase() ==
//                                     'pendiente') {
//                                   context.pushNamed(
//                                     '/Rdetails',
//                                     extra: request,
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Esta solicitud está ${request.estado} y no se puede ver el detalle.',
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: _buildRequestCard(request),
//                             ),
//                           );
//                         },
//                       );
//                     } else if (solicitudState is SolicitudError) {
//                       return const Center(
//                         child: Text(
//                           'Error al cargar solicitudes del técnico.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.red, fontSize: 16),
//                         ),
//                       );
//                     }
//                     return const Center(
//                       child: Text('Cargando solicitudes del técnico...'),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterButton(
//     String label,
//     String selectedValue,
//     List<String> items,
//     ValueChanged<String> onSelected,
//   ) {
//     return PopupMenuButton<String>(
//       initialValue: selectedValue,
//       onSelected: onSelected,
//       color: const Color(0xFFE0F2F7),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       itemBuilder:
//           (BuildContext context) =>
//               items
//                   .map(
//                     (item) => PopupMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(color: Color(0xFF424242)),
//                       ),
//                     ),
//                   )
//                   .toList(),
//       child: ElevatedButton(
//         onPressed: null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//           elevation: 3,
//           enabledMouseCursor: MaterialStateMouseCursor.clickable,
//         ),
//         child: Text(label, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }

//   Widget _buildRequestCard(SolicitudModel request) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE0F2F7),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   request.titulo,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF424242),
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Acción para solicitud: ${request.titulo}'),
//                     ),
//                   );
//                 },
//                 child: const Icon(
//                   Icons.more_vert,
//                   color: Color(0xFF424242),
//                   size: 24,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 20, thickness: 1, color: Colors.grey),
//           _buildInfoRow('Cliente:', request.cliente.firstName ?? 'N/A'),
//           _buildInfoRow('Categoría:', request.categoria.nombre ?? 'N/A'),
//           _buildInfoRow('Dirección:', request.direccion),
//           _buildInfoRow('Estado:', request.estado),
//         ],
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

//   List<SolicitudModel> _filterSolicitudes(List<SolicitudModel> solicitudes) {
//     return solicitudes.where((request) {
//       final matchesEstado =
//           (_selectedEstado == 'Todas' || request.estado == _selectedEstado);
//       final matchesCategoria =
//           (_selectedCategoria == 'Todas' ||
//               request.categoria.nombre == _selectedCategoria);
//       return matchesEstado && matchesCategoria;
//     }).toList();
//   }

//   void _filterRequests(BuildContext context) {
//     final profileState = context.read<ProfileBloc>().state;
//     if (profileState is ProfileLoaded && profileState.user != null) {
//       context.read<SolicitudBloc>().add(
//         GetSolicitudesByTecnicoEvent(profileState.user!.id!),
//       );
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

class RequestViewTecnico extends StatefulWidget {
  static const String name = '/RVtecnico';

  const RequestViewTecnico({super.key});

  @override
  State<RequestViewTecnico> createState() => _RequestViewTecnicoState();
}

class _RequestViewTecnicoState extends State<RequestViewTecnico> {
  String _selectedEstado = 'Todas';
  String _selectedCategoria = 'Todas';

  @override
  void initState() {
    super.initState();
    // Se obtiene el perfil primero, y el listener se encargará de llamar a lo demás.
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  void _filterRequests() {
    // La lógica de filtrado ahora es puramente en el lado del cliente,
    // por lo que solo necesitamos un `setState` para que el `BlocBuilder` reconstruya.
    setState(() {});
  }

  List<SolicitudModel> _filterSolicitudes(List<SolicitudModel> solicitudes) {
    return solicitudes.where((request) {
      final matchesEstado = _selectedEstado == 'Todas' || request.estado.toLowerCase() == _selectedEstado.toLowerCase();
      final matchesCategoria = _selectedCategoria == 'Todas' || request.categoria.nombre == _selectedCategoria;
      return matchesEstado && matchesCategoria;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return MultiBlocProvider(
      providers: [
        // No es necesario crear los BLoCs aquí si ya están provistos en un nivel superior.
        // Si no es así, esta es la forma correcta.
        BlocProvider(create: (context) => SolicitudBloc()),
        BlocProvider(create: (context) => TecnicoBloc()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 1),
        appBar: AppBar(
          title: Text('Mis Solicitudes', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterButton(
                      context: context,
                      label: 'Estado',
                      value: _selectedEstado,
                      items: ['Todas', 'pendiente', 'aceptado', 'rechazado', 'Finalizado'],
                      onSelected: (newValue) {
                        setState(() => _selectedEstado = newValue);
                        _filterRequests();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<TecnicoBloc, TecnicoState>(
                    builder: (context, tecnicoState) {
                      List<String> categorias = ['Todas'];
                      if (tecnicoState is TecnicoLoaded) {
                        categorias.addAll(tecnicoState.tecnico.categorias.map((c) => c.nombre!));
                      }
                      return Expanded(
                        child: _buildFilterButton(
                          context: context,
                          label: 'Categoría',
                          value: _selectedCategoria,
                          items: categorias.toSet().toList(), // Evitar duplicados
                          onSelected: (newValue) {
                            setState(() => _selectedCategoria = newValue);
                            _filterRequests();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, profileState) {
            if (profileState is ProfileLoaded && profileState.user != null) {
              final tecnicoId = profileState.user!.id!;
              context.read<SolicitudBloc>().add(GetSolicitudesByTecnicoEvent(tecnicoId));
              context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(tecnicoId));
            } else if (profileState is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al cargar datos del técnico.'), backgroundColor: Colors.red),
              );
            }
          },
          child: BlocBuilder<SolicitudBloc, SolicitudState>(
            builder: (context, solicitudState) {
              if (solicitudState is SolicitudesByTecnicoLoading) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              } else if (solicitudState is SolicitudesByTecnicoLoaded) {
                final List<SolicitudModel> filteredRequests = _filterSolicitudes(solicitudState.solicitudes);

                if (filteredRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No hay solicitudes', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
                          child: Text(
                            'No se encontraron solicitudes con los filtros seleccionados.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final SolicitudModel request = filteredRequests[index];
                    return SolicitudTecnicoCard(
                      request: request,
                      onTap: () {
                        // Navegar a los detalles solo si la solicitud está pendiente
                        if (request.estado.toLowerCase() == 'pendiente') {
                          context.pushNamed('/Rdetails', extra: request);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Esta solicitud ya fue ${request.estado}.')),
                          );
                        }
                      },
                    );
                  },
                );
              } else if (solicitudState is SolicitudError) {
                return Center(child: Text('Error al cargar solicitudes: '));
              }
              return const Center(child: Text('Cargando...'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return OutlinedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Seleccionar $label', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const Divider(height: 1),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index], style: GoogleFonts.poppins()),
                          onTap: () {
                            onSelected(items[index]);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF56A3A6),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}

// --- WIDGETS PERSONALIZADOS ---

class SolicitudTecnicoCard extends StatelessWidget {
  final SolicitudModel request;
  final VoidCallback onTap;

  const SolicitudTecnicoCard({super.key, required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      request.titulo,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusBadge(status: request.estado),
                ],
              ),
              const Divider(height: 24),
              _InfoRow(icon: Icons.person_outline, label: 'Cliente:', value: request.cliente.firstName ?? 'N/A'),
              _InfoRow(icon: Icons.category_outlined, label: 'Categoría:', value: request.categoria.nombre ?? 'N/A'),
              _InfoRow(icon: Icons.location_on_outlined, label: 'Dirección:', value: request.direccion),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[500], size: 18),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.poppins(color: Colors.grey[700])),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'aceptado':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'finalizado':
        color = const Color(0xFF56A3A6);
        icon = Icons.verified_outlined;
        break;
      case 'rechazado':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default: // pendiente
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
          Text(
            status,
            style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}