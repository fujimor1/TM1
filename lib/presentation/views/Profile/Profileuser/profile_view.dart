import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart'; 

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _currentUserId;
  UserModel? _originalUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges(UserModel currentUser) {
    final Map<String, dynamic> updatedData = {};

    if (_usernameController.text != (currentUser.username ?? '')) {
      updatedData['username'] = _usernameController.text;
    }
    if (_phoneController.text != (currentUser.telefono ?? '')) {
      updatedData['telefono'] = _phoneController.text.isNotEmpty ? _phoneController.text : null;
    }
    if (_emailController.text != (currentUser.correo ?? '')) {
      updatedData['correo'] = _emailController.text.isNotEmpty ? _emailController.text : null;
    }

    if (updatedData.isEmpty) {
      _showMessage('No hay cambios para guardar.', Colors.orange);
      return;
    }

    if (_currentUserId != null) {
      context.read<ProfileBloc>().add(
            ProfilePatchEvent(updatedData, _currentUserId!), 
          );
    } else {
      _showMessage('Error: ID de usuario no disponible para actualizar.', Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 2),
      appBar: AppBar(
        title: const Text(
          'Datos Socio Chambea Ya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.logout, color: Colors.black),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: profileBloc..add(ProfileGetEvent()),
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.user != null && (_originalUser == null || _originalUser!.id != state.user!.id)) {
              _usernameController.text = state.user!.username ?? '';
              _phoneController.text = state.user!.telefono ?? '';
              _emailController.text = state.user!.correo ?? '';
              _currentUserId = state.user!.id;
              _originalUser = state.user; 
            }

            if (_originalUser != null && state.user!.id == _originalUser!.id &&
                (state.user!.username != _originalUser!.username ||
                 state.user!.telefono != _originalUser!.telefono ||
                 state.user!.correo != _originalUser!.correo)) {
              _showMessage('¡Perfil actualizado con éxito!', Colors.green);
              _originalUser = state.user; 
            }
          } else if (state is ProfileError) {
            _showMessage('Error al cargar o actualizar el perfil: ', Colors.red);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ha ocurrido un error al cargar el perfil: '),
                  ElevatedButton(
                    onPressed: () {
                      profileBloc.add(ProfileGetEvent()); 
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            if (user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No se pudo cargar el perfil del usuario. Por favor, inicie sesión de nuevo.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        profileBloc.add(ProfileGetEvent());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DatoPerfil(label: 'Nombres', value: user.firstName),
                      DatoPerfil(
                        label: 'Apellidos',
                        value: user.lastName,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [DatoPerfil(label: 'N° DNI', value: user.dni)],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Datos de Contacto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CampoEditable(
                    label: 'Nombre de usuario',
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                  ),
                  CampoEditable(
                    label: 'Teléfono de contacto',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone, 
                  ),
                  CampoEditable(
                    label: 'Correo electrónico',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress, 
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _saveChanges(user);
                      },
                      child: const Text(
                        'Guardar Datos',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Cargando perfil...'));
        },
      ),
    );
  }
}