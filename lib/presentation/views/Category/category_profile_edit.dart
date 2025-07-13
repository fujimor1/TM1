// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';
// import 'package:tm1/presentation/bloc/FotoTrabajo/bloc/foto_trabajo_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

// class CategoryProfileEdit extends StatefulWidget {
//   final int tecnicoId;
//   final int categoriaId;

//   const CategoryProfileEdit(
//       {super.key, required this.tecnicoId, required this.categoriaId});
//   static String name = '/Cprofile';

//   @override
//   State<CategoryProfileEdit> createState() => _CategoryProfileEditState();
// }

// class _CategoryProfileEditState extends State<CategoryProfileEdit> {
//   final String _cloudinaryBaseUrl = 'https://res.cloudinary.com/delww5upv/';

//   String _descripcion = "Cargando...";
//   List<FotoTrabajoModel> _fotos = [];
//   int _currentIndex = 0;
  
//   File? _newImageFile;
//   bool _isUploading = false;
//   bool _isDeleting = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(widget.tecnicoId));
//     context.read<FotoTrabajoBloc>().add(
//           GetFotosByTecnicoAndCategoriaEvent(
//             tecnicoId: widget.tecnicoId,
//             categoriaId: widget.categoriaId,
//           ),
//         );
//   }
  
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _newImageFile = File(pickedFile.path);
//       });
//     }
//   }
  
//   void _nextImage() {
//     if (_fotos.isNotEmpty && _currentIndex < _fotos.length - 1) {
//       setState(() {
//         _currentIndex++;
//       });
//     }
//   }

//   void _previousImage() {
//     if (_currentIndex > 0) {
//       setState(() {
//         _currentIndex--;
//       });
//     }
//   }

//   void _uploadImage() {
//     if (_newImageFile != null) {
//       context.read<FotoTrabajoBloc>().add(
//         UploadFotoTrabajoEvent(
//           tecnicoId: widget.tecnicoId,
//           categoriaId: widget.categoriaId,
//           fotoPath: _newImageFile!.path,
//         ),
//       );
//     }
//   }

//   Future<void> _deleteImage() async {
//     if (_fotos.isEmpty) return;

//     final fotoAEliminar = _fotos[_currentIndex];

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirmar Eliminación'),
//           content: const Text('¿Estás seguro de que quieres eliminar esta foto? Esta acción no se puede deshacer.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancelar'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Eliminar'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmed == true) {
//       context.read<FotoTrabajoBloc>().add(
//             DeleteFotoTrabajoEvent(
//               fotoId: fotoAEliminar.id,
//               tecnicoId: widget.tecnicoId,
//               categoriaId: widget.categoriaId,
//             ),
//           );
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<TecnicoBloc, TecnicoState>(
//           listener: (context, state) {
//             if (state is TecnicoLoaded) {
//               setState(() {
//                 _descripcion = state.tecnico.descripcion ?? 'No se ha añadido una descripción.';
//               });
//             }
//           }
//         ),
//         BlocListener<FotoTrabajoBloc, FotoTrabajoState>(
//           listener: (context, state) {
//             setState(() {
//               _isUploading = state is FotoTrabajoUploading;
//               _isDeleting = state is FotoTrabajoDeleting;
//             });

//             if (state is FotoTrabajoUploadSuccess) {
//               setState(() => _newImageFile = null);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('¡Foto subida con éxito!'), backgroundColor: Colors.green),
//               );
//             } else if (state is FotoTrabajoDeleteSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Foto eliminada correctamente.'), backgroundColor: Colors.orange),
//               );
//             } else if (state is FotoTrabajoLoaded) {
//               setState(() {
//                 _fotos = state.fotos;
//                 if (_currentIndex >= _fotos.length) {
//                   _currentIndex = _fotos.isNotEmpty ? _fotos.length - 1 : 0;
//                 }
//               });
//             } else if (state is FotoTrabajoError){
//                ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red)
//               );
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Editar Perfil',
//               style: TextStyle(fontFamily: 'PatuaOne', fontSize: 30)),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: BlocBuilder<FotoTrabajoBloc, FotoTrabajoState>(
//             builder: (context, state) {
//               if (state is FotoTrabajoLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
//                   const SizedBox(height: 8.0),
//                   Container(
//                      width: double.infinity,
//                     padding: const EdgeInsets.all(12.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8.0),
//                       color: const Color(0xFFF2F2F6),
//                     ),
//                     child: Text(
//                       _descripcion,
//                       style: TextStyle(color: _descripcion.startsWith('No se ha') ? Colors.grey : Colors.black),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton.icon(
//                       onPressed: _isUploading || _isDeleting ? null : _pickImage,
//                       icon: const Icon(Icons.add),
//                       label: const Text('Agregar foto'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.black,
//                         side: const BorderSide(color: Colors.grey),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   const Center(child: Text('Máximo 10 imágenes', style: TextStyle(color: Colors.grey))),
//                   const SizedBox(height: 16.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios),
//                         onPressed: _newImageFile == null && _currentIndex > 0 && !_isDeleting ? _previousImage : null,
//                       ),
                      
//                       Container(
//                         width: 220.0, height: 220.0,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: _newImageFile != null
//                           ? Image.file(_newImageFile!, fit: BoxFit.cover)
//                           : _fotos.isNotEmpty && _fotos[_currentIndex].urlFoto.isNotEmpty
//                             ? Image.network(
//                                 '$_cloudinaryBaseUrl${_fotos[_currentIndex].urlFoto}',
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return const Center(child: CircularProgressIndicator());
//                                 },
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Icon(Icons.error, color: Colors.red);
//                                 },
//                               )
//                             : const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.image_outlined, size: 48.0, color: Colors.grey),
//                                   SizedBox(height: 8),
//                                   Text('No hay fotos', style: TextStyle(color: Colors.grey)),
//                                 ],
//                               ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.arrow_forward_ios),
//                         onPressed: _newImageFile == null && _fotos.isNotEmpty && _currentIndex < _fotos.length - 1 && !_isDeleting
//                             ? _nextImage
//                             : null,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _fotos.isNotEmpty && _newImageFile == null && !_isDeleting ? _deleteImage : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFEB3223),
//                         disabledBackgroundColor: Colors.grey,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       ),
//                       child: _isDeleting 
//                         ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
//                         : const Text('Eliminar foto', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w900)),
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _newImageFile != null && !_isUploading && !_isDeleting ? _uploadImage : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         disabledBackgroundColor: Colors.grey,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       ),
//                       child: _isUploading
//                         ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
//                         : const Text('Subir Foto Seleccionada', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';
import 'package:tm1/presentation/bloc/FotoTrabajo/bloc/foto_trabajo_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

class CategoryProfileEdit extends StatefulWidget {
  final int tecnicoId;
  final int categoriaId;

  const CategoryProfileEdit(
      {super.key, required this.tecnicoId, required this.categoriaId});
  static String name = '/Cprofile';

  @override
  State<CategoryProfileEdit> createState() => _CategoryProfileEditState();
}

class _CategoryProfileEditState extends State<CategoryProfileEdit> {
  // --- TODA TU LÓGICA ORIGINAL SE MANTIENE INTACTA ---
  final String _cloudinaryBaseUrl = 'https://res.cloudinary.com/delww5upv/';

  String _descripcion = "Cargando...";
  List<FotoTrabajoModel> _fotos = [];
  int _currentIndex = 0;
  
  File? _newImageFile;
  bool _isUploading = false;
  bool _isDeleting = false;

  // Se añade un PageController para manejar el nuevo carrusel visualmente
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(widget.tecnicoId));
    context.read<FotoTrabajoBloc>().add(
          GetFotosByTecnicoAndCategoriaEvent(
            tecnicoId: widget.tecnicoId,
            categoriaId: widget.categoriaId,
          ),
        );
  }

  @override
  void dispose() {
    _pageController.dispose(); // No olvides hacer dispose del controller
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  // _nextImage y _previousImage ya no son necesarios con PageView.
  // La navegación se maneja con el deslizamiento del usuario.

  void _uploadImage() {
    if (_newImageFile != null) {
      context.read<FotoTrabajoBloc>().add(
        UploadFotoTrabajoEvent(
          tecnicoId: widget.tecnicoId,
          categoriaId: widget.categoriaId,
          fotoPath: _newImageFile!.path,
        ),
      );
    }
  }

  Future<void> _deleteImage() async {
    if (_fotos.isEmpty) return;

    final fotoAEliminar = _fotos[_currentIndex];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // --- DIÁLOGO CON ESTILO ACTUALIZADO, MISMA LÓGICA ---
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirmar Eliminación', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text('¿Seguro que desea eliminar esta foto? La acción no se puede deshacer.', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Eliminar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<FotoTrabajoBloc>().add(
            DeleteFotoTrabajoEvent(
              fotoId: fotoAEliminar.id,
              tecnicoId: widget.tecnicoId,
              categoriaId: widget.categoriaId,
            ),
          );
    }
  }
  // --- FIN DE LA LÓGICA ORIGINAL ---

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Editar Categoría', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          // TUS BLOCLISTENERS ORIGINALES SIN CAMBIOS
          BlocListener<TecnicoBloc, TecnicoState>(
            listener: (context, state) {
              if (state is TecnicoLoaded) {
                setState(() {
                  _descripcion = state.tecnico.descripcion ?? 'No se ha añadido una descripción.';
                });
              }
            }
          ),
          BlocListener<FotoTrabajoBloc, FotoTrabajoState>(
            listener: (context, state) {
              setState(() {
                _isUploading = state is FotoTrabajoUploading;
                _isDeleting = state is FotoTrabajoDeleting;
              });

              if (state is FotoTrabajoUploadSuccess) {
                setState(() => _newImageFile = null);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Foto subida con éxito!'), backgroundColor: Colors.green),
                );
              } else if (state is FotoTrabajoDeleteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto eliminada correctamente.'), backgroundColor: Colors.orange),
                );
              } else if (state is FotoTrabajoLoaded) {
                setState(() {
                  _fotos = state.fotos;
                  if (_currentIndex >= _fotos.length) {
                    _currentIndex = _fotos.isNotEmpty ? _fotos.length - 1 : 0;
                  }
                });
              } else if (state is FotoTrabajoError){
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red)
                 );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FotoTrabajoBloc, FotoTrabajoState>(
            builder: (context, state) {
              if (state is FotoTrabajoLoading) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              }

              // --- INICIO DE LA NUEVA UI ---
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'Descripción',
                    child: Text(
                      _descripcion,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _descripcion.startsWith('No se ha') ? Colors.grey[600] : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Mis Trabajos',
                    child: Column(
                      children: [
                        _buildImageCarousel(),
                        const SizedBox(height: 12),
                        if (_fotos.isNotEmpty && _newImageFile == null) _buildDotIndicator(),
                        const SizedBox(height: 20),
                        _buildActionButtons(primaryColor),
                      ],
                    ),
                  ),
                ],
              );
              // --- FIN DE LA NUEVA UI ---
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCCIÓN DE UI (NUEVOS) ---

  Widget _buildImageCarousel() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _newImageFile != null
            ? Image.file(_newImageFile!, fit: BoxFit.cover)
            : _fotos.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: _fotos.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        '$_cloudinaryBaseUrl${_fotos[index].urlFoto}',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) =>
                            progress == null ? child : const Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stack) => const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_search, size: 48.0, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text('Aún no tienes fotos', style: GoogleFonts.poppins(color: Colors.grey[600])),
                    ],
                  ),
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_fotos.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? const Color(0xFF56A3A6) : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons(Color primaryColor) {
    bool canDelete = _fotos.isNotEmpty && _newImageFile == null && !_isDeleting && !_isUploading;
    bool canUpload = _newImageFile != null && !_isUploading && !_isDeleting;

    return Column(
      children: [
        if (canUpload) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _uploadImage,
              icon: _isUploading ? const SizedBox.shrink() : const Icon(Icons.cloud_upload_outlined, size: 20),
              label: _isUploading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Subir Foto Seleccionada'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading || _isDeleting ? null : _pickImage,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
                label: Text('Elegir Foto'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canDelete ? _deleteImage : null,
                icon: _isDeleting
                    ? const SizedBox.shrink()
                    : const Icon(Icons.delete_outline, size: 20),
                label: _isDeleting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('Eliminar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: canDelete ? Colors.red : Colors.grey,
                  side: BorderSide(color: canDelete ? Colors.red.withOpacity(0.5) : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ],
        ),
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
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}