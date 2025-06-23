import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        'fotos_solicitud': [], 
      };
      context.read<SolicitudBloc>().add(InsertSolicitudEvent(solicitudData));
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
    print('Tecnico ID recibido en build: ${widget.tecnicoId}');
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
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solicitud creada con éxito!'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.go('/Home');
              } else if (state is SolicitudError) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al crear la solicitud:'),
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
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Seleccionar imágenes de su dispositivo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
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