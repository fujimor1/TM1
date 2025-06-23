import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tm1/config/theme/app_colors.dart';
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
  final String _cloudinaryBaseUrl = 'https://res.cloudinary.com/delww5upv/';

  String _descripcion = "Cargando...";
  List<FotoTrabajoModel> _fotos = [];
  int _currentIndex = 0;
  
  File? _newImageFile;
  bool _isUploading = false;
  bool _isDeleting = false;

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
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }
  
  void _nextImage() {
    if (_fotos.isNotEmpty && _currentIndex < _fotos.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

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
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar esta foto? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
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


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil',
              style: TextStyle(fontFamily: 'PatuaOne', fontSize: 30)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FotoTrabajoBloc, FotoTrabajoState>(
            builder: (context, state) {
              if (state is FotoTrabajoLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 8.0),
                  Container(
                     width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xFFF2F2F6),
                    ),
                    child: Text(
                      _descripcion,
                      style: TextStyle(color: _descripcion.startsWith('No se ha') ? Colors.grey : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isUploading || _isDeleting ? null : _pickImage,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar foto'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Center(child: Text('Máximo 10 imágenes', style: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _newImageFile == null && _currentIndex > 0 && !_isDeleting ? _previousImage : null,
                      ),
                      
                      Container(
                        width: 220.0, height: 220.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: _newImageFile != null
                          ? Image.file(_newImageFile!, fit: BoxFit.cover)
                          : _fotos.isNotEmpty && _fotos[_currentIndex].urlFoto.isNotEmpty
                            ? Image.network(
                                '$_cloudinaryBaseUrl${_fotos[_currentIndex].urlFoto}',
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red);
                                },
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined, size: 48.0, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('No hay fotos', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _newImageFile == null && _fotos.isNotEmpty && _currentIndex < _fotos.length - 1 && !_isDeleting
                            ? _nextImage
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _fotos.isNotEmpty && _newImageFile == null && !_isDeleting ? _deleteImage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB3223),
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: _isDeleting 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Eliminar foto', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _newImageFile != null && !_isUploading && !_isDeleting ? _uploadImage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: _isUploading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Subir Foto Seleccionada', style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
