import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Llamamos a getCategories solo una vez al cargar la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().getCategories();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'CATEGORÍAS',
            style: TextStyle(
              fontFamily: 'PatuaOne',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoriesLoaded) {
                      final categorias = state.categories;

                      return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: categorias.map((cat) {
                          return InkWell(
                            onTap: () {
                              context.pushNamed(
                                '/TecnicosView',
                                pathParameters: {'categoria': cat['nombre']},
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5FB7B7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.build,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat['nombre'] ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    } else if (state is CategoriesError) {
                      return const Center(
                        child: Text('Error al cargar categorías'),
                      );
                    } else {
                      return const Center(
                        child: Text('No hay datos disponibles'),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
