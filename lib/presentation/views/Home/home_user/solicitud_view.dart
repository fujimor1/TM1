// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';
// import 'package:tm1/data/model/user/user_model.dart';

// class SolicitudServicioView extends StatefulWidget {
//   static const String name = '/Solicitud';

//   final String categoria;
//   final String distrito;
//   final int? tecnicoId;
//   final int? categoryId;

//   const SolicitudServicioView({
//     super.key,
//     required this.categoria,
//     required this.distrito,
//     this.tecnicoId,
//     this.categoryId,
//   });

//   @override
//   State<SolicitudServicioView> createState() => _SolicitudServicioViewState();
// }

// class _SolicitudServicioViewState extends State<SolicitudServicioView> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _addressController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _showConfirmationDialog(BuildContext context, UserModel? user) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Confirmar Solicitud'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('¿Está seguro de que desea enviar esta solicitud de servicio?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('No'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Sí'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _submitSolicitud(context, user);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _submitSolicitud(BuildContext context, UserModel? user) {
//     if (user != null && widget.categoryId != null) {
//       final solicitudData = {
//         'cliente_id': user.id, 
//         'tecnico_id': widget.tecnicoId,
//         'categoria_id': widget.categoryId,
//         'direccion': _addressController.text,
//         'titulo': _titleController.text,
//         'descripcion': _descriptionController.text,
//         'estado': 'pendiente',
//         'fotos_solicitud': [], 
//       };
//       context.read<SolicitudBloc>().add(InsertSolicitudEvent(solicitudData));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Faltan datos del usuario o categoría para crear la solicitud.'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('Tecnico ID recibido en build: ${widget.tecnicoId}');
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => ProfileBloc()..add(ProfileGetEvent())),
//         BlocProvider(create: (context) => SolicitudBloc()),
//       ],
//       child: Scaffold(
//         bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
//         appBar: AppBar(
//           title: const Text(
//             'SOLICITUD DE SERVICIO',
//             style: TextStyle(fontFamily: 'PatuaOne'),
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: BlocListener<SolicitudBloc, SolicitudState>(
//             listener: (context, state) {
//               if (state is SolicitudLoaded) {
//                 // Show success message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Solicitud creada con éxito!'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//                 context.go('/Home');
//               } else if (state is SolicitudError) {
//                 // Show error message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Error al crear la solicitud:'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: BlocBuilder<ProfileBloc, ProfileState>(
//               builder: (context, profileState) {
//                 if (profileState is ProfileLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (profileState is ProfileLoaded) {
//                   final UserModel? user = profileState.user;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomTextField(
//                         label: 'Título del problema',
//                         hintText: 'Ej. Llave atorada',
//                         controller: _titleController,
//                       ),
//                       CustomTextField(
//                         label: 'Categoría',
//                         hintText: widget.categoria,
//                         enabled: false,
//                       ),
//                       CustomTextField(
//                         label: 'Distrito',
//                         hintText: widget.distrito,
//                         enabled: false,
//                       ),
//                       CustomTextField(
//                         label: 'Dirección',
//                         hintText: 'Mz. M St. 3 Gr. 11',
//                         controller: _addressController,
//                       ),
//                       CustomTextField(
//                         label: 'Descripción del problema',
//                         hintText: 'Se rompió mi llave y se quedó dentro de la cerradura.',
//                         keyboardType: TextInputType.multiline,
//                         controller: _descriptionController,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Adjuntar fotos (las que usted considere necesarias)',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 12),
//                       Container(
//                         width: double.infinity,
//                         height: 140,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.image_outlined, size: 40, color: Colors.grey),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Seleccionar imágenes de su dispositivo',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 28),
//                       Center(
//                         child: BlocBuilder<SolicitudBloc, SolicitudState>(
//                           builder: (context, solicitudState) {
//                             return ElevatedButton(
//                               onPressed: solicitudState is SolicitudLoading
//                                   ? null
//                                   : () {
//                                       _showConfirmationDialog(context, user);
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF5FB7B7),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: solicitudState is SolicitudLoading
//                                   ? const CircularProgressIndicator(color: Colors.white)
//                                   : const Text(
//                                       'Enviar solicitud',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 } else if (profileState is ProfileError) {
//                   return const Center(
//                     child: Text('Error al cargar los datos del usuario. Por favor, intente de nuevo.'),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// lib/presentation/views/solicitud/solicitud_servicio_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';
import 'package:tm1/data/model/user/user_model.dart';

class SolicitudServicioView extends StatefulWidget {
  static const String name = '/Solicitud';

  final String categoria;
  final String distrito;
  final int? tecnicoId;
  final int? categoryId;

  const SolicitudServicioView({
    super.key,
    required this.categoria,
    required this.distrito,
    this.tecnicoId,
    this.categoryId,
  });

  @override
  State<SolicitudServicioView> createState() => _SolicitudServicioViewState();
}

class _SolicitudServicioViewState extends State<SolicitudServicioView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // --- CAMBIO: Añadimos estado para las imágenes ---
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- CAMBIO: Nueva función para seleccionar imágenes ---
  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80, // Opcional: comprime un poco la imagen
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles);
        });
      }
    } catch (e) {
      print('Error al seleccionar imágenes: $e');
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, UserModel? user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Solicitud'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea enviar esta solicitud de servicio?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _submitSolicitud(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  // --- CAMBIO: Modificamos cómo se envía la solicitud ---
  void _submitSolicitud(BuildContext context, UserModel? user) {
    if (user != null && widget.categoryId != null) {
      final solicitudData = {
        'cliente_id': user.id,
        'tecnico_id': widget.tecnicoId,
        'categoria_id': widget.categoryId,
        'direccion': _addressController.text,
        'titulo': _titleController.text,
        'descripcion': _descriptionController.text,
        'estado': 'pendiente',
        'fotos_solicitud': [], // El backend ya no necesita esto aquí
      };
      
      // Convertimos los XFile a una lista de rutas (String)
      final photoPaths = _selectedImages.map((file) => file.path).toList();
      
      // Despachamos el único evento con toda la información
      context.read<SolicitudBloc>().add(InsertSolicitudEvent(solicitudData, photoPaths));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos del usuario o categoría para crear la solicitud.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()..add(ProfileGetEvent())),
        BlocProvider(create: (context) => SolicitudBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
        appBar: AppBar(
          title: const Text(
            'SOLICITUD DE SERVICIO',
            style: TextStyle(fontFamily: 'PatuaOne'),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocListener<SolicitudBloc, SolicitudState>(
            listener: (context, state) {
              if (state is SolicitudLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solicitud creada con éxito!'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.go('/Home');
              } else if (state is SolicitudError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al crear la solicitud.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (profileState is ProfileLoaded) {
                  final UserModel? user = profileState.user;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... Tus CustomTextFields se mantienen igual
                      CustomTextField(
                        label: 'Título del problema',
                        hintText: 'Ej. Llave atorada',
                        controller: _titleController,
                      ),
                      CustomTextField(
                        label: 'Categoría',
                        hintText: widget.categoria,
                        enabled: false,
                      ),
                      CustomTextField(
                        label: 'Distrito',
                        hintText: widget.distrito,
                        enabled: false,
                      ),
                      CustomTextField(
                        label: 'Dirección',
                        hintText: 'Mz. M St. 3 Gr. 11',
                        controller: _addressController,
                      ),
                      CustomTextField(
                        label: 'Descripción del problema',
                        hintText: 'Se rompió mi llave y se quedó dentro de la cerradura.',
                        keyboardType: TextInputType.multiline,
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Adjuntar fotos (las que usted considere necesarias)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      
                      // --- CAMBIO: El contenedor de imágenes ahora es interactivo ---
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _selectedImages.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text(
                                        'Toque aquí para seleccionar imágenes',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_selectedImages[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 28),
                      Center(
                        child: BlocBuilder<SolicitudBloc, SolicitudState>(
                          builder: (context, solicitudState) {
                            return ElevatedButton(
                              onPressed: solicitudState is SolicitudLoading
                                  ? null
                                  : () {
                                      _showConfirmationDialog(context, user);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5FB7B7),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: solicitudState is SolicitudLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Enviar solicitud',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (profileState is ProfileError) {
                  return const Center(
                    child: Text('Error al cargar los datos del usuario. Por favor, intente de nuevo.'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}