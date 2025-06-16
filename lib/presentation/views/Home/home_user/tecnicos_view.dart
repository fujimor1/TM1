import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    print('Id de la categoria seleccionado: ${widget.categoryId}');
    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.categoria.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            // Text('Técnicos de ${widget.categoria} (ID: ${widget.categoryId})'),
            BlocBuilder<DistrictCubit, DistrictState>(
              builder: (context, state) {
                if (state is DistrictLoaded) {
                  return Text(
                    distritoSeleccionado ?? 'Todos los distritos',
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                  );
                } else if (state is DistrictLoading) {
                  return const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                } else if (state is DistrictError) {
                  return const Text(
                    'Error al cargar distritos',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        actions: [
          BlocBuilder<DistrictCubit, DistrictState>(
            builder: (context, state) {
              if (state is DistrictLoaded) {
                final distritos = state.district.map((e) => e['nombre'] as String).toList();

                return PopupMenuButton<String>(
                  icon: const Icon(Icons.location_on),
                  onSelected: (value) {
                    setState(() {
                      distritoSeleccionado = value;
                    });
                    _loadTecnicos(); // Recarga los técnicos al cambiar el distrito
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: null, // Opción para "Todos los distritos"
                        child: Text('Todos los distritos'),
                      ),
                      ...distritos.map((d) {
                        return PopupMenuItem(
                          value: d,
                          child: Text(d),
                        );
                      }).toList(),
                    ];
                  },
                );
              } else if (state is DistrictLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<TecnicoBloc, TecnicoState>(
          builder: (context, state) {
            if (state is TecnicoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TecnicosListLoaded) {
              final tecnicos = state.tecnicos;

              if (tecnicos.isEmpty) {
                return const Center(
                  child: Text('No se encontraron técnicos para la selección.'),
                );
              }

              return GridView.builder(
                itemCount: tecnicos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final tecnico = tecnicos[index];
                  final nombre = tecnico.usuario.username ?? 'Nombre Desconocido';
                  final rating = tecnico.calificacion ?? 0;
                  // final imagen = tecnico.usuario.imagen ?? 'https://via.placeholder.com/100'; 

                  return InkWell(
                    onTap: () {
                      context.pushNamed('/DetallesTecnico', 
                      extra: {
                        'tecnico': tecnico,
                        'categoria': widget.categoria,
                        'distrito': distritoSeleccionado,
                        'id': widget.categoryId,
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.shade200, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(16),
                          //   child: Image.network(
                          //     imagen,
                          //     width: 100,
                          //     height: 100,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < rating ? Icons.star : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is TecnicoError) {
              return Center(
                child: Text('Error al cargar técnicos: "Desconocido"}'),
              );
            }
            return const Center(
              child: Text('Selecciona una categoría para ver los técnicos.'),
            );
          },
        ),
      ),
    );
  }
}