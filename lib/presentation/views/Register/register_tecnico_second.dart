import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart'; // Importa go_router para navegación
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:tm1/presentation/widgets/CategoriaSelector.dart';

class RegisterTecnicoSecond extends StatefulWidget {
  const RegisterTecnicoSecond({super.key, this.id});
  static String name = '/RSTecnico';

  final String? id;

  @override
  State<RegisterTecnicoSecond> createState() => _RegisterTecnicoSecondState();
}

class _RegisterTecnicoSecondState extends State<RegisterTecnicoSecond> {
  final List<Map<String, dynamic>> selectedCategoriesData = [];
  final List<Map<String, dynamic>> selectedDistrictsData = [];

  File? imagenSeleccionada;

  Map<String, int> _categoryNameToIdMap = {};
  Map<int, String> _categoryIdToNameMap = {};
  Map<String, int> _districtNameToIdMap = {};
  Map<int, String> _districtIdToNameMap = {};

  @override
  void initState() {
    super.initState();

    debugPrint(
      'RegisterTecnicoSecond (RSTecnico) initState - ID recibido: ${widget.id}',
    );

    context.read<CategoriesCubit>().getCategories();
    context.read<DistrictCubit>().getDistricts();
  }

  void toggleCategoria(Map<String, dynamic> categoriaData) {
    setState(() {
      final int id = categoriaData['id'] as int;
      if (selectedCategoriesData.any((element) => element['id'] == id)) {
        selectedCategoriesData.removeWhere((element) => element['id'] == id);
      } else {
        if (selectedCategoriesData.length < 3) {
          selectedCategoriesData.add(categoriaData);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solo puedes seleccionar hasta 3 categorías'),
            ),
          );
        }
      }
    });
  }

  void seleccionarDistrito(Map<String, dynamic> distritoData) {
    setState(() {
      final int id = distritoData['id'] as int;
      if (selectedDistrictsData.any((element) => element['id'] == id)) {
        selectedDistrictsData.removeWhere((element) => element['id'] == id);
      } else {
        if (selectedDistrictsData.length < 2) {
          selectedDistrictsData.add(distritoData);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solo puedes seleccionar hasta 2 distritos'),
            ),
          );
        }
      }
    });
  }

  Future<void> seleccionarImagenDesdeGaleria() async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        imagenSeleccionada = File(imagen.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia de TecnicoBloc
    final tecnicoBloc = context.read<TecnicoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Técnico',
          style: TextStyle(fontFamily: 'PatuaOne'),
        ),
      ),
      body: BlocListener<TecnicoBloc, TecnicoState>(
        bloc: tecnicoBloc, // Escucha el TecnicoBloc
        listener: (context, state) {
          if (state is TecnicoLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Técnico registrado exitosamente!')),
            );
            debugPrint('Técnico ID: ${state.tecnico.usuario.id} registrado.');
            // Navega a la siguiente pantalla (ej. dashboard del técnico)
            context.go('/login_screen');
          } else if (state is TecnicoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al registrar técnico: }')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 16.0)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<DistrictCubit, DistrictState>(
                      builder: (context, state) {
                        if (state is DistrictLoaded) {
                          _districtNameToIdMap = {
                            for (var d in state.district)
                              d['nombre'] as String: d['id'] as int,
                          };
                          _districtIdToNameMap = {
                            for (var d in state.district)
                              d['id'] as int: d['nombre'] as String,
                          };

                          final distritos = state.district;

                          return ElevatedButton.icon(
                            onPressed: () async {
                              final List<Map<String, dynamic>>?
                              seleccionadosTemp = await showDialog<
                                List<Map<String, dynamic>>
                              >(
                                context: context,
                                builder: (context) {
                                  final List<Map<String, dynamic>>
                                  dialogSelectedData = List.from(
                                    selectedDistrictsData,
                                  );

                                  return AlertDialog(
                                    title: const Text('Seleccionar distritos'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: StatefulBuilder(
                                        // Usamos StatefulBuilder para actualizar el diálogo
                                        builder: (
                                          BuildContext context,
                                          StateSetter setState,
                                        ) {
                                          return ListView(
                                            shrinkWrap: true,
                                            children:
                                                distritos.map<Widget>((
                                                  distrito,
                                                ) {
                                                  final nombre =
                                                      distrito['nombre']
                                                          as String;
                                                  final id =
                                                      distrito['id'] as int;
                                                  final isSelected =
                                                      dialogSelectedData.any(
                                                        (element) =>
                                                            element['id'] == id,
                                                      );

                                                  return CheckboxListTile(
                                                    title: Text(nombre),
                                                    value: isSelected,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        // setState del StatefulBuilder
                                                        if (value == true) {
                                                          if (dialogSelectedData
                                                                  .length <
                                                              2) {
                                                            dialogSelectedData
                                                                .add({
                                                                  'id': id,
                                                                  'nombre':
                                                                      nombre,
                                                                });
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Solo puedes seleccionar hasta 2 distritos',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          dialogSelectedData
                                                              .removeWhere(
                                                                (element) =>
                                                                    element['id'] ==
                                                                    id,
                                                              );
                                                        }
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            () => Navigator.pop(
                                              context,
                                              dialogSelectedData,
                                            ),
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (seleccionadosTemp != null) {
                                setState(() {
                                  selectedDistrictsData
                                    ..clear()
                                    ..addAll(seleccionadosTemp);
                                });
                              }
                            },
                            icon: const Icon(Icons.location_on),
                            label: Text(
                              selectedDistrictsData.isEmpty
                                  ? 'Seleccionar distritos'
                                  : selectedDistrictsData
                                      .map((e) => e['nombre'])
                                      .join(', '),
                            ),
                          );
                        } else if (state is DistrictLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Text('Error al cargar distritos');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: seleccionarImagenDesdeGaleria,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          imagenSeleccionada != null
                              ? FileImage(imagenSeleccionada!)
                              : const AssetImage('assets/images/Contaco.png')
                                  as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Seleccione máximo 3 categorías',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  if (state is CategoriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoriesLoaded) {
                    // Almacenar los mapeos de nombres a IDs y viceversa
                    _categoryNameToIdMap = {
                      for (var c in state.categories)
                        c['nombre'] as String: c['id'] as int,
                    };
                    _categoryIdToNameMap = {
                      for (var c in state.categories)
                        c['id'] as int: c['nombre'] as String,
                    };

                    final categorias = state.categories;

                    return GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          categorias.map<Widget>((cat) {
                            final nombre = cat['nombre'] ?? 'Sin nombre';
                            final id = cat['id'] as int;
                            final isSelected = selectedCategoriesData.any(
                              (element) => element['id'] == id,
                            );

                            return CategoriaSelector(
                              nombre: nombre,
                              estaSeleccionado: isSelected,
                              onTap:
                                  () => toggleCategoria({
                                    'id': id,
                                    'nombre': nombre,
                                  }),
                            );
                          }).toList(),
                    );
                  } else if (state is CategoriesError) {
                    return const Center(
                      child: Text('Error al cargar categorías'),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.id != null) {
                    final usuarioId = int.tryParse(widget.id!);
                    if (usuarioId != null) {
                      // Obtener solo los IDs de las categorías y distritos seleccionados
                      final List<int> categoryIds =
                          selectedCategoriesData
                              .map<int>((data) => data['id'] as int)
                              .toList();
                      final List<int> districtIds =
                          selectedDistrictsData
                              .map<int>((data) => data['id'] as int)
                              .toList();

                      // Validar que se hayan seleccionado al menos una categoría y un distrito
                      if (categoryIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, selecciona al menos una categoría.',
                            ),
                          ),
                        );
                        return;
                      }
                      if (districtIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, selecciona al menos un distrito.',
                            ),
                          ),
                        );
                        return;
                      }

                      // Dispara el evento para registrar el técnico con todos los datos
                      tecnicoBloc.add(
                        InsertTecnicoEvent(usuarioId, categoryIds, districtIds),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: ID de usuario inválido.'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: ID de usuario no disponible.'),
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
                child: BlocBuilder<TecnicoBloc, TecnicoState>(
                  bloc:
                      tecnicoBloc, // Escucha los estados del TecnicoBloc para el botón
                  builder: (context, state) {
                    if (state is TecnicoLoading) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    return const Text(
                      'Completar Registro', // Texto del botón actualizado
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
