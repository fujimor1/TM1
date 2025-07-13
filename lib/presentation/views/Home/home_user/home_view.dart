// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CategoriesCubit>().getCategories();
//     });

//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'CATEGORÍAS',
//             style: TextStyle(
//               fontFamily: 'PatuaOne',
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: BlocBuilder<CategoriesCubit, CategoriesState>(
//                   builder: (context, state) {
//                     if (state is CategoriesLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (state is CategoriesLoaded) {
//                       final categorias = state.categories;

//                       return GridView.count(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 20,
//                         crossAxisSpacing: 20,
//                         children: categorias.map((cat) {
//                           return InkWell(
//                             onTap: () {
//                               context.pushNamed(
//                                 '/TecnicosView',
//                                 extra: {
//                                   'categoria': cat['nombre'],
//                                   'id': cat['id'],
//                                 },
//                               );
//                             },
//                             borderRadius: BorderRadius.circular(12),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(30),
//                                   decoration: const BoxDecoration(
//                                     color: Color.fromARGB(255, 234, 245, 245),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.build,
//                                     size: 40,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   cat['nombre'] ?? 'Sin nombre',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     } else if (state is CategoriesError) {
//                       return const Center(
//                         child: Text('Error al cargar categorías'),
//                       );
//                     } else {
//                       return const Center(
//                         child: Text('No hay datos disponibles'),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Es una mejor práctica llamar a eventos de BLoC en initState.
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
      appBar: AppBar(
        title: Center(
          child: Text(
            'CATEGORÍAS',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (state is CategoriesLoaded) {
                final categorias = state.categories;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1.0, // Ajustado para hacer el card más cuadrado
                  ),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final cat = categorias[index];
                    return CategoryCard(
                      categoryName: cat['nombre'] ?? 'Sin nombre',
                      onTap: () {
                        context.pushNamed(
                          '/TecnicosView',
                          extra: {
                            'categoria': cat['nombre'],
                            'id': cat['id'],
                          },
                        );
                      },
                    );
                  },
                );
              } else if (state is CategoriesError) {
                return Center(
                  child: Text(
                    'Error al cargar categorías',
                    style: GoogleFonts.poppins(),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'No hay datos disponibles',
                    style: GoogleFonts.poppins(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,   // Centrado Vertical
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado Horizontal
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.widgets_rounded, // Ícono cambiado
                  color: primaryColor,
                  size: 35,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                categoryName,
                textAlign: TextAlign.center, // Asegura que el texto de varias líneas esté centrado
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}