// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
// import 'package:tm1/presentation/bloc/district/district_cubit.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/widgets/CategoriaSelector.dart';

// class RegisterTecnicoSecond extends StatefulWidget {
//   const RegisterTecnicoSecond({super.key, this.id});
//   static String name = '/RSTecnico';

//   final String? id;

//   @override
//   State<RegisterTecnicoSecond> createState() => _RegisterTecnicoSecondState();
// }

// class _RegisterTecnicoSecondState extends State<RegisterTecnicoSecond> {
//   final List<Map<String, dynamic>> selectedCategoriesData = [];
//   final List<Map<String, dynamic>> selectedDistrictsData = [];

//   File? imagenSeleccionada;

//   Map<String, int> _categoryNameToIdMap = {};
//   Map<int, String> _categoryIdToNameMap = {};
//   Map<String, int> _districtNameToIdMap = {};
//   Map<int, String> _districtIdToNameMap = {};

//   @override
//   void initState() {
//     super.initState();

//     debugPrint(
//         'RegisterTecnicoSecond (RSTecnico) initState - ID recibido: ${widget.id}',
//     );

//     context.read<CategoriesCubit>().getCategories();
//     context.read<DistrictCubit>().getDistricts();
//   }

//   void toggleCategoria(Map<String, dynamic> categoriaData) {
//     setState(() {
//       final int id = categoriaData['id'] as int;
//       if (selectedCategoriesData.any((element) => element['id'] == id)) {
//         selectedCategoriesData.removeWhere((element) => element['id'] == id);
//       } else {
//         if (selectedCategoriesData.length < 3) {
//           selectedCategoriesData.add(categoriaData);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Solo puedes seleccionar hasta 3 categorías'),
//             ),
//           );
//         }
//       }
//     });
//   }

//   void seleccionarDistrito(Map<String, dynamic> distritoData) {
//     setState(() {
//       final int id = distritoData['id'] as int;
//       if (selectedDistrictsData.any((element) => element['id'] == id)) {
//         selectedDistrictsData.removeWhere((element) => element['id'] == id);
//       } else {
//         if (selectedDistrictsData.length < 2) {
//           selectedDistrictsData.add(distritoData);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Solo puedes seleccionar hasta 2 distritos'),
//             ),
//           );
//         }
//       }
//     });
//   }

//   Future<void> seleccionarImagenDesdeGaleria() async {
//     final picker = ImagePicker();
//     final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
//     if (imagen != null) {
//       setState(() {
//         imagenSeleccionada = File(imagen.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Obtén la instancia de TecnicoBloc
//     final tecnicoBloc = context.read<TecnicoBloc>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Registro de Técnico',
//           style: TextStyle(fontFamily: 'PatuaOne'),
//         ),
//       ),
//       body: BlocListener<TecnicoBloc, TecnicoState>(
//         bloc: tecnicoBloc, // Escucha el TecnicoBloc
//         listener: (context, state) {
//           if (state is TecnicoLoaded) {
//             debugPrint('TecnicoLoaded detectado. ID de técnico: ${state.tecnico.usuario.id}');
//             if (imagenSeleccionada != null) {
//               debugPrint('Disparando UpdateTecnicoProfileEvent con imagen...');
//               tecnicoBloc.add(
//                 UpdateTecnicoProfileEvent(
//                   state.tecnico.usuario.id!, 
//                   {'foto_perfil': imagenSeleccionada!},
//                 ),
//               );

//               setState(() {
//               imagenSeleccionada = null;
//             });

//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Técnico registrado exitosamente!')),
//               );
//               debugPrint('Técnico ID: ${state.tecnico.usuario.id} registrado.');
//               context.go('/login_screen');
//             }
//           } else if (state is TecnicoError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error al registrar técnico: ${state.props.first}')),
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               const Padding(padding: EdgeInsets.only(bottom: 16.0)),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: BlocBuilder<DistrictCubit, DistrictState>(
//                       builder: (context, state) {
//                         if (state is DistrictLoaded) {
//                           _districtNameToIdMap = {
//                             for (var d in state.district)
//                               d['nombre'] as String: d['id'] as int,
//                           };
//                           _districtIdToNameMap = {
//                             for (var d in state.district)
//                               d['id'] as int: d['nombre'] as String,
//                           };

//                           final distritos = state.district;

//                           return ElevatedButton.icon(
//                             onPressed: () async {
//                               final List<Map<String, dynamic>>?
//                                   seleccionadosTemp = await showDialog<
//                                       List<Map<String, dynamic>>>(
//                                 context: context,
//                                 builder: (context) {
//                                   final List<Map<String, dynamic>>
//                                       dialogSelectedData = List.from(
//                                     selectedDistrictsData,
//                                   );

//                                   return AlertDialog(
//                                     title: const Text('Seleccionar distritos'),
//                                     content: SizedBox(
//                                       width: double.maxFinite,
//                                       child: StatefulBuilder(
//                                         builder: (
//                                           BuildContext context,
//                                           StateSetter setState,
//                                         ) {
//                                           return ListView(
//                                             shrinkWrap: true,
//                                             children:
//                                                 distritos.map<Widget>((
//                                                   distrito,
//                                                 ) {
//                                                   final nombre =
//                                                       distrito['nombre']
//                                                           as String;
//                                                   final id =
//                                                       distrito['id'] as int;
//                                                   final isSelected =
//                                                       dialogSelectedData.any(
//                                                     (element) =>
//                                                         element['id'] == id,
//                                                   );

//                                                   return CheckboxListTile(
//                                                     title: Text(nombre),
//                                                     value: isSelected,
//                                                     onChanged: (bool? value) {
//                                                       setState(() {
//                                                         // setState del StatefulBuilder
//                                                         if (value == true) {
//                                                           if (dialogSelectedData
//                                                                   .length <
//                                                               2) {
//                                                             dialogSelectedData
//                                                                 .add({
//                                                               'id': id,
//                                                               'nombre': nombre,
//                                                             });
//                                                           } else {
//                                                             ScaffoldMessenger.of(
//                                                                     context)
//                                                                 .showSnackBar(
//                                                               const SnackBar(
//                                                                 content: Text(
//                                                                   'Solo puedes seleccionar hasta 2 distritos',
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           }
//                                                         } else {
//                                                           dialogSelectedData
//                                                               .removeWhere(
//                                                             (element) =>
//                                                                 element['id'] ==
//                                                                 id,
//                                                           );
//                                                         }
//                                                       });
//                                                     },
//                                                   );
//                                                 }).toList(),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context),
//                                         child: const Text('Cancelar'),
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () => Navigator.pop(
//                                           context,
//                                           dialogSelectedData,
//                                         ),
//                                         child: const Text('Aceptar'),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                               if (seleccionadosTemp != null) {
//                                 setState(() {
//                                   selectedDistrictsData
//                                     ..clear()
//                                     ..addAll(seleccionadosTemp);
//                                 });
//                               }
//                             },
//                             icon: const Icon(Icons.location_on),
//                             label: Text(
//                               selectedDistrictsData.isEmpty
//                                   ? 'Seleccionar distritos'
//                                   : selectedDistrictsData
//                                       .map((e) => e['nombre'])
//                                       .join(', '),
//                             ),
//                           );
//                         } else if (state is DistrictLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else {
//                           return const Text('Error al cargar distritos');
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: seleccionarImagenDesdeGaleria,
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: imagenSeleccionada != null
//                           ? FileImage(imagenSeleccionada!)
//                           : const AssetImage('assets/images/Contaco.png')
//                               as ImageProvider,
//                       backgroundColor: Colors.grey[200],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Seleccione máximo 3 categorías',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               BlocBuilder<CategoriesCubit, CategoriesState>(
//                 builder: (context, state) {
//                   if (state is CategoriesLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is CategoriesLoaded) {
//                     // Almacenar los mapeos de nombres a IDs y viceversa
//                     _categoryNameToIdMap = {
//                       for (var c in state.categories)
//                         c['nombre'] as String: c['id'] as int,
//                     };
//                     _categoryIdToNameMap = {
//                       for (var c in state.categories)
//                         c['id'] as int: c['nombre'] as String,
//                     };

//                     final categorias = state.categories;

//                     return GridView.count(
//                       crossAxisCount: 3,
//                       shrinkWrap: true,
//                       mainAxisSpacing: 12,
//                       crossAxisSpacing: 12,
//                       childAspectRatio: 2.5,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: categorias.map<Widget>((cat) {
//                         final nombre = cat['nombre'] ?? 'Sin nombre';
//                         final id = cat['id'] as int;
//                         final isSelected = selectedCategoriesData.any(
//                           (element) => element['id'] == id,
//                         );

//                         return CategoriaSelector(
//                           nombre: nombre,
//                           estaSeleccionado: isSelected,
//                           onTap: () => toggleCategoria({
//                             'id': id,
//                             'nombre': nombre,
//                           }),
//                         );
//                       }).toList(),
//                     );
//                   } else if (state is CategoriesError) {
//                     return const Center(
//                       child: Text('Error al cargar categorías'),
//                     );
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (widget.id != null) {
//                     final usuarioId = int.tryParse(widget.id!);
//                     if (usuarioId != null) {
//                       // Obtener solo los IDs de las categorías y distritos seleccionados
//                       final List<int> categoryIds = selectedCategoriesData
//                           .map<int>((data) => data['id'] as int)
//                           .toList();
//                       final List<int> districtIds = selectedDistrictsData
//                           .map<int>((data) => data['id'] as int)
//                           .toList();

//                       // Validar que se hayan seleccionado al menos una categoría y un distrito
//                       if (categoryIds.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text(
//                               'Por favor, selecciona al menos una categoría.',
//                             ),
//                           ),
//                         );
//                         return;
//                       }
//                       if (districtIds.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text(
//                               'Por favor, selecciona al menos un distrito.',
//                             ),
//                           ),
//                         );
//                         return;
//                       }

//                       // Dispara el evento para registrar el técnico con todos los datos
//                       tecnicoBloc.add(
//                         InsertTecnicoEvent(usuarioId, categoryIds, districtIds),
//                       );
//                       // La lógica para la imagen ahora se maneja en el BlocListener
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Error: ID de usuario inválido.'),
//                         ),
//                       );
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Error: ID de usuario no disponible.'),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 15,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: BlocBuilder<TecnicoBloc, TecnicoState>(
//                   bloc:
//                       tecnicoBloc, // Escucha los estados del TecnicoBloc para el botón
//                   builder: (context, state) {
//                     if (state is TecnicoLoading) {
//                       return const CircularProgressIndicator(
//                         color: Colors.white,
//                       );
//                     }
//                     return const Text(
//                       'Completar Registro', // Texto del botón actualizado
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

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
    debugPrint('RegisterTecnicoSecond (RSTecnico) initState - ID recibido: ${widget.id}');
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
            const SnackBar(content: Text('Solo puedes seleccionar hasta 3 categorías')),
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
            const SnackBar(content: Text('Solo puedes seleccionar hasta 2 distritos')),
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
    final tecnicoBloc = context.read<TecnicoBloc>();
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Registro de Socio', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<TecnicoBloc, TecnicoState>(
        bloc: tecnicoBloc,
        listener: (context, state) {
          if (state is TecnicoLoaded) {
            debugPrint('TecnicoLoaded detectado. ID de técnico: ${state.tecnico.usuario.id}');
            if (imagenSeleccionada != null) {
              debugPrint('Disparando UpdateTecnicoProfileEvent con imagen...');
              tecnicoBloc.add(
                UpdateTecnicoProfileEvent(state.tecnico.usuario.id!, {'foto_perfil': imagenSeleccionada!}),
              );
              setState(() => imagenSeleccionada = null);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Técnico registrado exitosamente!')));
              debugPrint('Técnico ID: ${state.tecnico.usuario.id} registrado.');
              context.go('/login_screen');
            }
          } else if (state is TecnicoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al registrar técnico: ${state.props.first}')),
            );
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                children: [
                  _buildStepper(),
                  const SizedBox(height: 24),
                  _buildSectionCard(title: 'Foto de Perfil', child: _buildImagePicker()),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Área de Trabajo',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selecciona hasta 2 distritos', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
                        const SizedBox(height: 8),
                        _buildDistrictPicker(context),
                        const SizedBox(height: 20),
                        Text('Selecciona hasta 3 categorías', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
                        const SizedBox(height: 12),
                        _buildCategoryPicker(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: BlocBuilder<TecnicoBloc, TecnicoState>(
                  bloc: tecnicoBloc,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is TecnicoLoading ? null : () {
                        if (widget.id != null) {
                          final usuarioId = int.tryParse(widget.id!);
                          if (usuarioId != null) {
                            final List<int> categoryIds = selectedCategoriesData.map<int>((data) => data['id'] as int).toList();
                            final List<int> districtIds = selectedDistrictsData.map<int>((data) => data['id'] as int).toList();
                            if (categoryIds.isEmpty || districtIds.isEmpty || imagenSeleccionada == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, completa todos los campos: foto, categorías y distritos.')));
                              return;
                            }
                            tecnicoBloc.add(InsertTecnicoEvent(usuarioId, categoryIds, districtIds));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is TecnicoLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Completar Registro', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStep(isActive: false, label: '1', title: 'Datos'),
        const Expanded(child: Divider(color: Color(0xFF56A3A6), thickness: 1.5)),
        _buildStep(isActive: true, label: '2', title: 'Perfil'),
      ],
    );
  }

  Widget _buildStep({required bool isActive, required String label, required String title}) {
    final color = isActive ? const Color(0xFF56A3A6) : Colors.grey.shade400;
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color,
          child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: seleccionarImagenDesdeGaleria,
        child: imagenSeleccionada != null
            ? CircleAvatar(radius: 60, backgroundImage: FileImage(imagenSeleccionada!))
            : DottedBorder(
                color: Colors.grey.shade400,
                strokeWidth: 2,
                dashPattern: const [6, 6],
                borderType: BorderType.Circle,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade600, size: 30),
                      const SizedBox(height: 4),
                      Text('Añadir foto', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDistrictPicker(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final districtCubit = context.read<DistrictCubit>();
        if (districtCubit.state is DistrictLoaded) {
          final distritos = (districtCubit.state as DistrictLoaded).district;
          final List<Map<String, dynamic>>? seleccionadosTemp = await showDialog<List<Map<String, dynamic>>>(
            context: context,
            builder: (context) {
              final List<Map<String, dynamic>> dialogSelectedData = List.from(selectedDistrictsData);
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('Seleccionar distritos', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                content: SizedBox(
                  width: double.maxFinite,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setStateDialog) {
                      return ListView(
                        shrinkWrap: true,
                        children: distritos.map<Widget>((distrito) {
                          final isSelected = dialogSelectedData.any((element) => element['id'] == distrito['id']);
                          return CheckboxListTile(
                            title: Text(distrito['nombre'], style: GoogleFonts.poppins()),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setStateDialog(() {
                                // --- INICIO DE CORRECCIÓN ---
                                final distritoTyped = Map<String, dynamic>.from(distrito);
                                if (value == true) {
                                  if (dialogSelectedData.length < 2) {
                                    dialogSelectedData.add(distritoTyped);
                                  } else {
                                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solo puedes seleccionar hasta 2 distritos')));
                                  }
                                } else {
                                  dialogSelectedData.removeWhere((element) => element['id'] == distritoTyped['id']);
                                }
                                // --- FIN DE CORRECCIÓN ---
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[700]))),
                  ElevatedButton(onPressed: () => Navigator.pop(context, dialogSelectedData), child: Text('Aceptar', style: GoogleFonts.poppins()), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF56A3A6), foregroundColor: Colors.white)),
                ],
              );
            },
          );
          if (seleccionadosTemp != null) {
            setState(() { selectedDistrictsData..clear()..addAll(seleccionadosTemp); });
          }
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              selectedDistrictsData.isEmpty ? 'Seleccionar distritos' : selectedDistrictsData.map((e) => e['nombre']).join(', '),
              style: GoogleFonts.poppins(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          _categoryNameToIdMap = {for (var c in state.categories) c['nombre'] as String: c['id'] as int};
          _categoryIdToNameMap = {for (var c in state.categories) c['id'] as int: c['nombre'] as String};
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: state.categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final cat = state.categories[index];
              final nombre = cat['nombre'] ?? '';
              final isSelected = selectedCategoriesData.any((c) => c['id'] == cat['id']);
              return ChoiceChip(
                label: Text(nombre, style: GoogleFonts.poppins(fontSize: 12)),
                selected: isSelected,
                onSelected: (bool selected) {
                  final categoriaTipada = Map<String, dynamic>.from(cat);
                  toggleCategoria(categoriaTipada);
                },
                selectedColor: const Color(0xFF56A3A6).withAlpha(51),
                side: BorderSide(color: isSelected ? const Color(0xFF56A3A6) : Colors.grey.shade300),
                showCheckmark: false,
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}