import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIS CATEGORÍAS',
          style: TextStyle(fontFamily: 'PatuaOne', fontSize: 30),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const Custombottomnavigationbartecnico(
        currentIndex: 2,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfileLoaded) {
            final userId = profileState.user!.id;
            if (userId != null) {
              context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(userId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: No se pudo obtener el ID de usuario.'),
                ),
              );
            }
          } else if (profileState is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al cargar el perfil de usuario.'),
              ),
            );
          }
        },
        child: BlocBuilder<TecnicoBloc, TecnicoState>(
          builder: (context, tecnicoState) {
            if (tecnicoState is TecnicoLoading ||
                tecnicoState is TecnicoInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tecnicoState is TecnicoError) {
              return const Center(
                child: Text(
                  'Ocurrió un error al cargar los datos del técnico.',
                ),
              );
            }
            if (tecnicoState is TecnicoLoaded) {
              final tecnico = tecnicoState.tecnico;
              final tecnicoId = tecnico.usuario.id;
              final categorias = tecnico.categorias;
              if (categorias.isEmpty) {
                return const Center(
                  child: Text(
                    'No tienes categorías asignadas.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView.separated(
                  itemCount: categorias.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
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
                              const SnackBar(
                                content: Text(
                                  'Error: El ID del técnico no está disponible.',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          categoria.nombre?.toUpperCase() ?? 'SIN NOMBRE',
                          style: const TextStyle(
                            fontFamily: 'PatuaOne',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
