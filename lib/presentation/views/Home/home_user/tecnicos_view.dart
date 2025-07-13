// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/presentation/bloc/district/district_cubit.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class TecnicosView extends StatefulWidget {
//   static const String name = '/TecnicosView';

//   final String categoria;
//   final int? categoryId;

//   const TecnicosView({super.key, required this.categoria, this.categoryId});

//   @override
//   State<TecnicosView> createState() => _TecnicosViewState();
// }

// class _TecnicosViewState extends State<TecnicosView> {
//   String? distritoSeleccionado;

//   @override
//   void initState() {
//     super.initState();
//     context.read<DistrictCubit>().getDistricts();
//     _loadTecnicos();
//   }

//   void _loadTecnicos() {
//     context.read<TecnicoBloc>().add(
//       LoadTecnicosByCategoryAndDistrict(
//         categoryName: widget.categoria,
//         districtName: distritoSeleccionado,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String baseUrl = 'https://res.cloudinary.com/delww5upv/'; 

//     return Scaffold(
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.categoria.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
//             BlocBuilder<DistrictCubit, DistrictState>(
//               builder: (context, state) {
//                 if (state is DistrictLoaded) {
//                   return Text(
//                     distritoSeleccionado ?? 'Todos los distritos',
//                     style: const TextStyle(fontSize: 14, color: Colors.blue),
//                   );
//                 } else if (state is DistrictLoading) {
//                   return const SizedBox(
//                     height: 16,
//                     width: 16,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   );
//                 } else if (state is DistrictError) {
//                   return const Text(
//                     'Error al cargar distritos',
//                     style: TextStyle(fontSize: 14, color: Colors.red),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//         actions: [
//           BlocBuilder<DistrictCubit, DistrictState>(
//             builder: (context, state) {
//               if (state is DistrictLoaded) {
//                 final distritos = state.district.map((e) => e['nombre'] as String).toList();

//                 return PopupMenuButton<String>(
//                   icon: const Icon(Icons.location_on),
//                   onSelected: (value) {
//                     setState(() {
//                       distritoSeleccionado = value;
//                     });
//                     _loadTecnicos();
//                   },
//                   itemBuilder: (context) {
//                     return [
//                       const PopupMenuItem(
//                         value: null,
//                         child: Text('Todos los distritos'),
//                       ),
//                       ...distritos.map((d) {
//                         return PopupMenuItem(
//                           value: d,
//                           child: Text(d),
//                         );
//                       }).toList(),
//                     ];
//                   },
//                 );
//               } else if (state is DistrictLoading) {
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Center(
//                     child: SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   ),
//                 );
//               } else {
//                 return const SizedBox.shrink();
//               }
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: BlocBuilder<TecnicoBloc, TecnicoState>(
//           builder: (context, state) {
//             if (state is TecnicoLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is TecnicosListLoaded) {
//               final tecnicos = state.tecnicos;

//               if (tecnicos.isEmpty) {
//                 return const Center(
//                   child: Text('No se encontraron técnicos para la selección.'),
//                 );
//               }

//               return GridView.builder(
//                 itemCount: tecnicos.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 20,
//                   crossAxisSpacing: 20,
//                   childAspectRatio: 0.85,
//                 ),
//                 itemBuilder: (context, index) {
//                   final tecnico = tecnicos[index];
//                   final nombre = tecnico.usuario.username ?? 'Nombre Desconocido';
//                   final rating = tecnico.calificacion ?? 0;
                  
//                   String imagen = tecnico.fotoPerfil ?? '';
//                   if (!imagen.startsWith('http')) {
//                     imagen = '$baseUrl$imagen';
//                   }

//                   return InkWell(
//                     onTap: () {
//                       context.pushNamed('/DetallesTecnico',
//                         extra: {
//                           'tecnico': tecnico,
//                           'categoria': widget.categoria,
//                           'distrito': distritoSeleccionado,
//                           'id': widget.categoryId,
//                         },
//                       );
//                     },
//                     borderRadius: BorderRadius.circular(16),
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.green.shade200, width: 2),
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4,
//                                 offset: Offset(2, 2),
//                               )
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.network(
//                               imagen,
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           nombre,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             5,
//                             (i) => Icon(
//                               i < rating ? Icons.star : Icons.star_border,
//                               size: 16,
//                               color: Colors.amber,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             } else if (state is TecnicoError) {
//               return const Center(
//                 child: Text('Error al cargar técnicos.'),
//               );
//             }
//             return const Center(
//               child: Text('Selecciona una categoría para ver los técnicos.'),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:tm1/data/model/tecnico/tecnico_model.dart';
// import 'package:tm1/presentation/bloc/district/district_cubit.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class TecnicosView extends StatefulWidget {
//   static const String name = '/TecnicosView';
//   final String categoria;
//   final int? categoryId;

//   const TecnicosView({super.key, required this.categoria, this.categoryId});

//   @override
//   State<TecnicosView> createState() => _TecnicosViewState();
// }

// class _TecnicosViewState extends State<TecnicosView> {
//   String? distritoSeleccionado;

//   @override
//   void initState() {
//     super.initState();
//     context.read<DistrictCubit>().getDistricts();
//     _loadTecnicos();
//   }

//   void _loadTecnicos() {
//     context.read<TecnicoBloc>().add(
//           LoadTecnicosByCategoryAndDistrict(
//             categoryName: widget.categoria,
//             districtName: distritoSeleccionado,
//           ),
//         );
//   }

//   void _showDistrictFilter() {
//     final districtCubit = context.read<DistrictCubit>();
//     if (districtCubit.state is! DistrictLoaded) return;

//     final districts = (districtCubit.state as DistrictLoaded).district;

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Filtrar por Distrito',
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//               const Divider(height: 1),
//               Flexible(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: districts.length + 1, // +1 for "Todos"
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       return ListTile(
//                         title: Text('Todos los distritos', style: GoogleFonts.poppins()),
//                         onTap: () {
//                           setState(() => distritoSeleccionado = null);
//                           _loadTecnicos();
//                           Navigator.pop(context);
//                         },
//                       );
//                     }
//                     final district = districts[index - 1];
//                     return ListTile(
//                       title: Text(district['nombre'] as String, style: GoogleFonts.poppins()),
//                       onTap: () {
//                         setState(() => distritoSeleccionado = district['nombre'] as String);
//                         _loadTecnicos();
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF56A3A6);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
//       appBar: AppBar(
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           widget.categoria.toUpperCase(),
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50.0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: OutlinedButton.icon(
//               onPressed: _showDistrictFilter,
//               icon: const Icon(Icons.location_on_outlined, size: 18),
//               label: Text(distritoSeleccionado ?? 'Todos los distritos'),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: primaryColor,
//                 side: BorderSide(color: Colors.grey.shade300),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: BlocBuilder<TecnicoBloc, TecnicoState>(
//         builder: (context, state) {
//           if (state is TecnicoLoading) {
//             return const Center(child: CircularProgressIndicator(color: primaryColor));
//           } else if (state is TecnicosListLoaded) {
//             final tecnicos = state.tecnicos;
//             if (tecnicos.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.person_search_outlined, size: 80, color: Colors.grey[400]),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No se encontraron técnicos',
//                       style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
//                     ),
//                      Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
//                        child: Text(
//                         'Prueba seleccionando otra categoría o distrito.',
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
//                                      ),
//                      ),
//                   ],
//                 ),
//               );
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: tecnicos.length,
//               itemBuilder: (context, index) {
//                 final tecnico = tecnicos[index];
//                 return TecnicoCard(
//                   tecnico: tecnico,
//                   onTap: () {
//                     context.pushNamed('/DetallesTecnico', extra: {
//                       'tecnico': tecnico,
//                       'categoria': widget.categoria,
//                       'distrito': distritoSeleccionado,
//                       'id': widget.categoryId,
//                     });
//                   },
//                 );
//               },
//             );
//           } else if (state is TecnicoError) {
//             return Center(child: Text('Error al cargar técnicos: ${state.message}'));
//           }
//           return const Center(child: Text('Selecciona una categoría para ver los técnicos.'));
//         },
//       ),
//     );
//   }
// }

// // WIDGET PERSONALIZADO PARA LA TARJETA DE TÉCNICO
// class TecnicoCard extends StatelessWidget {
//   final TecnicoModel tecnico;
//   final VoidCallback onTap;
//   const TecnicoCard({super.key, required this.tecnico, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     const String baseUrl = 'https://res.cloudinary.com/delww5upv/';
//     String imagen = tecnico.fotoPerfil ?? '';
//     if (!imagen.startsWith('http')) {
//       imagen = '$baseUrl$imagen';
//     }

//     return Card(
//       color: Colors.white,
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       shadowColor: Colors.grey.withOpacity(0.2),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 35,
//                 backgroundColor: Colors.grey.shade200,
//                 backgroundImage: NetworkImage(imagen),
//                 onBackgroundImageError: (_, __) {},
//                 child: tecnico.fotoPerfil == null
//                     ? const Icon(Icons.person, size: 40, color: Colors.grey)
//                     : null,
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${tecnico.usuario.firstName} ${tecnico.usuario.lastName}',
//                       style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       tecnico.categorias.first.nombre ?? 'Especialista',
//                       style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 13),
//                     ),
//                     const SizedBox(height: 6),
//                     RatingBarIndicator(
//                       rating: tecnico.calificacion?.toDouble() ?? 0.0,
//                       itemBuilder: (context, index) => const Icon(
//                         Icons.star_rounded,
//                         color: Colors.amber,
//                       ),
//                       itemCount: 5,
//                       itemSize: 18.0,
//                       direction: Axis.horizontal,
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.chevron_right, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class TecnicosView extends StatefulWidget {
  static const String name = '/TecnicosView';
  final String categoria;
  final int? categoryId;

  const TecnicosView({super.key, required this.categoria, this.categoryId});

  @override
  State<TecnicosView> createState() => _TecnicosViewState();
}

class _TecnicosViewState extends State<TecnicosView> {
  String? distritoSeleccionado;

  @override
  void initState() {
    super.initState();
    context.read<DistrictCubit>().getDistricts();
    _loadTecnicos();
  }

  void _loadTecnicos() {
    context.read<TecnicoBloc>().add(
          LoadTecnicosByCategoryAndDistrict(
            categoryName: widget.categoria,
            districtName: distritoSeleccionado,
          ),
        );
  }

  void _showDistrictFilter() {
    final districtCubit = context.read<DistrictCubit>();
    if (districtCubit.state is! DistrictLoaded) return;

    final districts = (districtCubit.state as DistrictLoaded).district;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Filtrar por Distrito',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: districts.length + 1, // +1 for "Todos"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text('Todos los distritos', style: GoogleFonts.poppins()),
                        onTap: () {
                          setState(() => distritoSeleccionado = null);
                          _loadTecnicos();
                          Navigator.pop(context);
                        },
                      );
                    }
                    final district = districts[index - 1];
                    return ListTile(
                      title: Text(district['nombre'] as String, style: GoogleFonts.poppins()),
                      onTap: () {
                        setState(() => distritoSeleccionado = district['nombre'] as String);
                        _loadTecnicos();
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
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.categoria.toUpperCase(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: OutlinedButton.icon(
              onPressed: _showDistrictFilter,
              icon: const Icon(Icons.location_on_outlined, size: 18),
              label: Text(distritoSeleccionado ?? 'Todos los distritos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<TecnicoBloc, TecnicoState>(
        builder: (context, state) {
          if (state is TecnicoLoading) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          } else if (state is TecnicosListLoaded) {
            // 1. Filtra la lista para obtener solo técnicos con suscripción activa.
            final tecnicosActivos = state.tecnicos
                .where((tecnico) => tecnico.suscripcionActiva == true)
                .toList();

            // 2. Comprueba si la NUEVA lista está vacía.
            if (tecnicosActivos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No se encontraron técnicos activos', // Mensaje actualizado
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
                      child: Text(
                        'Prueba seleccionando otro distrito o revisa más tarde.', // Mensaje actualizado
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 3. Usa la lista filtrada para construir el ListView.
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tecnicosActivos.length, // Usa el tamaño de la lista filtrada
              itemBuilder: (context, index) {
                final tecnico = tecnicosActivos[index]; // Obtiene el técnico de la lista filtrada
                return TecnicoCard(
                  tecnico: tecnico,
                  onTap: () {
                    context.pushNamed('/DetallesTecnico', extra: {
                      'tecnico': tecnico,
                      'categoria': widget.categoria,
                      'distrito': distritoSeleccionado,
                      'id': widget.categoryId,
                    });
                  },
                );
              },
            );
          } else if (state is TecnicoError) {
            return Center(child: Text('Error al cargar técnicos: ${state.message}'));
          }
          return const Center(child: Text('Selecciona una categoría para ver los técnicos.'));
        },
      ),
    );
  }
}

// WIDGET PERSONALIZADO PARA LA TARJETA DE TÉCNICO
class TecnicoCard extends StatelessWidget {
  final TecnicoModel tecnico;
  final VoidCallback onTap;
  const TecnicoCard({super.key, required this.tecnico, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'https://res.cloudinary.com/delww5upv/';
    String imagen = tecnico.fotoPerfil ?? '';
    if (!imagen.startsWith('http')) {
      imagen = '$baseUrl$imagen';
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(imagen),
                onBackgroundImageError: (_, __) {},
                child: tecnico.fotoPerfil == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tecnico.usuario.firstName} ${tecnico.usuario.lastName}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tecnico.categorias.first.nombre ?? 'Especialista',
                      style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    RatingBarIndicator(
                      rating: tecnico.calificacion?.toDouble() ?? 0.0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 18.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}