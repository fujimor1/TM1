// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

// class CategoryView extends StatefulWidget {
//   const CategoryView({super.key});

//   @override
//   State<CategoryView> createState() => _CategoryViewState();
// }

// class _CategoryViewState extends State<CategoryView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'MIS CATEGORÍAS',
//           style: TextStyle(fontFamily: 'PatuaOne', fontSize: 30),
//         ),
//         centerTitle: true,
//       ),
//       bottomNavigationBar: const Custombottomnavigationbartecnico(
//         currentIndex: 2,
//       ),
//       body: BlocListener<ProfileBloc, ProfileState>(
//         listener: (context, profileState) {
//           if (profileState is ProfileLoaded) {
//             final userId = profileState.user!.id;
//             if (userId != null) {
//               context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(userId));
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Error: No se pudo obtener el ID de usuario.'),
//                 ),
//               );
//             }
//           } else if (profileState is ProfileError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Error al cargar el perfil de usuario.'),
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<TecnicoBloc, TecnicoState>(
//           builder: (context, tecnicoState) {
//             if (tecnicoState is TecnicoLoading ||
//                 tecnicoState is TecnicoInitial) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (tecnicoState is TecnicoError) {
//               return const Center(
//                 child: Text(
//                   'Ocurrió un error al cargar los datos del técnico.',
//                 ),
//               );
//             }
//             if (tecnicoState is TecnicoLoaded) {
//               final tecnico = tecnicoState.tecnico;
//               final tecnicoId = tecnico.usuario.id;
//               final categorias = tecnico.categorias;
//               if (categorias.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No tienes categorías asignadas.',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 );
//               }
//               return Padding(
//                 padding: const EdgeInsets.all(25.0),
//                 child: ListView.separated(
//                   itemCount: categorias.length,
//                   separatorBuilder:
//                       (context, index) => const SizedBox(height: 20),
//                   itemBuilder: (context, index) {
//                     final categoria = categorias[index];
//                     return SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           final categoriaId = categoria.id;
//                           if (tecnicoId != null) {
//                             context.push(
//                               '/Cprofile',
//                               extra: {
//                                 'tecnicoId': tecnicoId,
//                                 'categoriaId': categoriaId,
//                               },
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Error: El ID del técnico no está disponible.',
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           categoria.nombre?.toUpperCase() ?? 'SIN NOMBRE',
//                           style: const TextStyle(
//                             fontFamily: 'PatuaOne',
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Mis Categorías',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 2),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileLoaded) {
            final userId = profileState.user?.id;
            if (userId != null) {
              context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(userId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: No se pudo obtener el ID de usuario.')),
              );
            }
          } else if (profileState is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al cargar el perfil de usuario.')),
            );
          }
        },
        child: BlocBuilder<TecnicoBloc, TecnicoState>(
          builder: (context, tecnicoState) {
            if (tecnicoState is TecnicoLoading || tecnicoState is TecnicoInitial) {
              return const Center(child: CircularProgressIndicator(color: primaryColor));
            }

            if (tecnicoState is TecnicoError) {
              return Center(child: Text('Ocurrió un error: ${tecnicoState.message}'));
            }

            if (tecnicoState is TecnicoLoaded) {
              final tecnico = tecnicoState.tecnico;
              final tecnicoId = tecnico.usuario.id;
              final categorias = tecnico.categorias;

              if (categorias.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes categorías asignadas',
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return CategoryTile(
                    categoryName: categoria.nombre?.toUpperCase() ?? 'SIN NOMBRE',
                    onTap: () {
                      final categoriaId = categoria.id;
                      if (tecnicoId != null) {
                        context.push(
                          '/Cprofile',
                          extra: {
                            'tecnicoId': tecnicoId,
                            'categoriaId': categoriaId,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: El ID del técnico no está disponible.')),
                        );
                      }
                    },
                  );
                },
              );
            }
            return const Center(child: Text('Cargando datos del técnico...'));
          },
        ),
      ),
    );
  }
}

// WIDGET PERSONALIZADO PARA CADA CATEGORÍA
class CategoryTile extends StatelessWidget {
  final String categoryName;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const CircleAvatar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.work_outline),
        ),
        title: Text(
          categoryName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}