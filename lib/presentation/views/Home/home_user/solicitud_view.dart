// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
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

//   // --- CAMBIO: Añadimos estado para las imágenes ---
//   final List<XFile> _selectedImages = [];
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _addressController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   // --- CAMBIO: Nueva función para seleccionar imágenes ---
//   Future<void> _pickImages() async {
//     try {
//       final List<XFile> pickedFiles = await _picker.pickMultiImage(
//         imageQuality: 80, // Opcional: comprime un poco la imagen
//       );
//       if (pickedFiles.isNotEmpty) {
//         setState(() {
//           _selectedImages.addAll(pickedFiles);
//         });
//       }
//     } catch (e) {
//       print('Error al seleccionar imágenes: $e');
//     }
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

//   // --- CAMBIO: Modificamos cómo se envía la solicitud ---
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
//         'fotos_solicitud': [], // El backend ya no necesita esto aquí
//       };
      
//       // Convertimos los XFile a una lista de rutas (String)
//       final photoPaths = _selectedImages.map((file) => file.path).toList();
      
//       // Despachamos el único evento con toda la información
//       context.read<SolicitudBloc>().add(InsertSolicitudEvent(solicitudData, photoPaths));
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
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Solicitud creada con éxito!'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//                 context.go('/Home');
//               } else if (state is SolicitudError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Error al crear la solicitud.'),
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
//                       // ... Tus CustomTextFields se mantienen igual
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
                      
//                       // --- CAMBIO: El contenedor de imágenes ahora es interactivo ---
//                       GestureDetector(
//                         onTap: _pickImages,
//                         child: Container(
//                           width: double.infinity,
//                           height: 140,
//                           padding: const EdgeInsets.all(8.0),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: _selectedImages.isEmpty
//                               ? const Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.image_outlined, size: 40, color: Colors.grey),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         'Toque aquí para seleccionar imágenes',
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : GridView.builder(
//                                   gridDelegate:
//                                       const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 4,
//                                     crossAxisSpacing: 8,
//                                     mainAxisSpacing: 8,
//                                   ),
//                                   itemCount: _selectedImages.length,
//                                   itemBuilder: (context, index) {
//                                     return ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.file(
//                                         File(_selectedImages[index].path),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     );
//                                   },
//                                 ),
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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart'; // Necesitarás este paquete
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Puedes seleccionar un máximo de 5 imágenes.')));
      return;
    }
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.take(5 - _selectedImages.length));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al seleccionar imágenes: $e')));
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }
  
  void _submitSolicitud(BuildContext context, UserModel? user) {
    if (!_formKey.currentState!.validate()) {
      return; // Si el formulario no es válido, no hacer nada.
    }

    if (user != null && widget.categoryId != null) {
      final solicitudData = {
        'cliente_id': user.id,
        'tecnico_id': widget.tecnicoId,
        'categoria_id': widget.categoryId,
        'direccion': _addressController.text,
        'titulo': _titleController.text,
        'descripcion': _descriptionController.text,
        'estado': 'pendiente',
      };
      
      final photoPaths = _selectedImages.map((file) => file.path).toList();
      context.read<SolicitudBloc>().add(InsertSolicitudEvent(solicitudData, photoPaths));
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos de usuario o categoría.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, UserModel? user) async {
    if (!_formKey.currentState!.validate()){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos requeridos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirmar Solicitud', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('¿Desea enviar esta solicitud de servicio?', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[700])),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Sí, Enviar', style: GoogleFonts.poppins(color: const Color(0xFF56A3A6), fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()..add(ProfileGetEvent())),
        BlocProvider(create: (context) => SolicitudBloc()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Nueva Solicitud', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocListener<SolicitudBloc, SolicitudState>(
          listener: (context, state) {
            if (state is SolicitudLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Solicitud creada con éxito!'), backgroundColor: Colors.green));
              context.go('/Home');
            } else if (state is SolicitudError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la solicitud: '), backgroundColor: Colors.red));
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              if (profileState is ProfileLoading) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              } else if (profileState is ProfileLoaded) {
                return Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             _buildInfoCard(
                              title: 'Detalles del Servicio',
                              children: [
                                TextFormField(
                                  controller: _titleController,
                                  decoration: _inputDecoration('Título del problema', 'Ej. Fuga de agua en la cocina'),
                                  validator: (value) => value!.isEmpty ? 'El título es requerido' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: widget.categoria,
                                  readOnly: true,
                                  decoration: _inputDecoration('Categoría', '').copyWith(fillColor: Colors.grey.shade200),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: widget.distrito,
                                  readOnly: true,
                                  decoration: _inputDecoration('Distrito', '').copyWith(fillColor: Colors.grey.shade200),
                                ),
                              ],
                            ),
                             _buildInfoCard(
                              title: 'Tu Ubicación',
                              children: [
                                TextFormField(
                                  controller: _addressController,
                                  decoration: _inputDecoration('Dirección exacta', 'Ej. Av. Principal 123, Dpto 404'),
                                  validator: (value) => value!.isEmpty ? 'La dirección es requerida' : null,
                                )
                              ],
                            ),
                            _buildInfoCard(
                              title: 'Describe el Problema',
                              children: [
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: _inputDecoration('Descripción detallada', 'Mientras más detalles, mejor.'),
                                  maxLines: 5,
                                  validator: (value) => value!.isEmpty ? 'La descripción es requerida' : null,
                                )
                              ],
                            ),
                             _buildInfoCard(
                              title: 'Fotos de Referencia',
                              children: [
                                _buildImagePicker(),
                              ],
                            ),
                            const SizedBox(height: 100), // Espacio para el botón fijo
                          ],
                        ),
                      ),
                      // Botón de acción fijo
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                           decoration: BoxDecoration(
                            color: Colors.grey[100],
                            boxShadow: [
                               BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                            ]
                          ),
                          child: BlocBuilder<SolicitudBloc, SolicitudState>(
                             builder: (context, solicitudState) {
                               return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: solicitudState is SolicitudLoading
                                    ? null 
                                    : () => _showConfirmationDialog(context, profileState.user),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: solicitudState is SolicitudLoading 
                                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    : Text(
                                      'Enviar Solicitud',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                ),
                              );
                             },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return const Center(child: Text('Error al cargar datos del usuario.'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: DottedBorder(
            color: Colors.grey.shade400,
            strokeWidth: 2,
            dashPattern: const [6, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600, size: 30),
                  const SizedBox(height: 8),
                  Text('Añadir fotos', style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(_selectedImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
  
  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.poppins(),
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
       enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF56A3A6), width: 2),
      ),
    );
  }
}