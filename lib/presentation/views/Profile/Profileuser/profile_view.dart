// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/user/user_model.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   int? _currentUserId;
//   UserModel? _originalUser;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _showConfirmationDialog(BuildContext context, UserModel currentUser) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Confirmar Actualización de Perfil'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('¿Está seguro de que desea guardar los cambios en su perfil?'),
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
//                 _performSaveChanges(currentUser); 
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performSaveChanges(UserModel currentUser) {
//     final Map<String, dynamic> updatedData = {};

//     if (_usernameController.text != (currentUser.username ?? '')) {
//       updatedData['username'] = _usernameController.text;
//     }
//     if (_phoneController.text != (currentUser.telefono ?? '')) {
//       updatedData['telefono'] = _phoneController.text.isNotEmpty ? _phoneController.text : null;
//     }
//     if (_emailController.text != (currentUser.correo ?? '')) {
//       updatedData['correo'] = _emailController.text.isNotEmpty ? _emailController.text : null;
//     }

//     if (updatedData.isEmpty) {
//       _showMessage('No hay cambios para guardar.', Colors.orange);
//       return;
//     }

//     if (_currentUserId != null) {
//       context.read<ProfileBloc>().add(
//             ProfilePatchEvent(updatedData, _currentUserId!),
//           );
//     } else {
//       _showMessage('Error: ID de usuario no disponible para actualizar.', Colors.red);
//     }
//   }

//   void _showMessage(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileBloc = context.read<ProfileBloc>();

//     return Scaffold(
//       bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 2),
//       appBar: AppBar(
//         title: const Text(
//           'Datos Socio Chambea Ya',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(12),
//             child: 
//             // Icon(Icons.logout, color: Colors.black),
//             IconButton(
//               onPressed: (){
//                 context.go('/login_screen');
//               },  
//               icon: Icon(Icons.logout, color: Colors.teal,)
//             )
//           ),
//         ],
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: BlocConsumer<ProfileBloc, ProfileState>(
//         bloc: profileBloc..add(ProfileGetEvent()),
//         listener: (context, state) {
//           if (state is ProfileLoaded) {
//             if (state.user != null && (_originalUser == null || state.user! != _originalUser!)) {
//               _usernameController.text = state.user!.username ?? '';
//               _phoneController.text = state.user!.telefono ?? '';
//               _emailController.text = state.user!.correo ?? '';
//               _currentUserId = state.user!.id;
            
//               if (_originalUser != null && state.user!.id == _originalUser!.id) {
//                  _showMessage('¡Perfil actualizado con éxito!', Colors.green);
//               }
//               _originalUser = state.user; 
//             }
//           } else if (state is ProfileError) {
//             _showMessage('Error al cargar o actualizar el perfil.', Colors.red);
//           }
//         },
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ProfileError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Ha ocurrido un error al cargar el perfil.'),
//                   ElevatedButton(
//                     onPressed: () {
//                       profileBloc.add(ProfileGetEvent());
//                     },
//                     child: const Text('Reintentar'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (state is ProfileLoaded) {
//             final user = state.user;
//             if (user == null) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'No se pudo cargar el perfil del usuario. Por favor, inicie sesión de nuevo.',
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         profileBloc.add(ProfileGetEvent());
//                       },
//                       child: const Text('Reintentar'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       DatoPerfil(label: 'Nombres', value: user.firstName),
//                       DatoPerfil(
//                         label: 'Apellidos',
//                         value: user.lastName,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [DatoPerfil(label: 'N° DNI', value: user.dni)],
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Datos de Contacto',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   CampoEditable(
//                     label: 'Nombre de usuario',
//                     controller: _usernameController,
//                     keyboardType: TextInputType.text,
//                   ),
//                   // CampoEditable(
//                   //   label: 'Teléfono de contacto',
//                   //   controller: _phoneController,
//                   //   keyboardType: TextInputType.phone,
//                   // ),
//                   CampoEditable(
//                     label: 'Correo electrónico',
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 28),
//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 36,
//                           vertical: 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         _showConfirmationDialog(context, user);
//                       },
//                       child: const Text(
//                         'Guardar Datos',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const Center(child: Text('Cargando perfil...'));
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

// Asegúrate de que este archivo exista o define el color directamente.
// import 'package:tm1/config/theme/app_colors.dart'; 

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
    // Es una mejor práctica llamar eventos de BLoC aquí.
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _performSaveChanges(UserModel currentUser) {
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
      _showMessage('Error: ID de usuario no disponible.', Colors.red);
    }
  }
  
  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, UserModel currentUser) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirmar Cambios', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text('¿Desea guardar los cambios en su perfil?', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey[700])),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Guardar', style: GoogleFonts.poppins(color: const Color(0xFF56A3A6), fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performSaveChanges(currentUser);
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 2),
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/login_screen'),
            icon: const Icon(Icons.logout_outlined, color: Colors.black54),
            tooltip: 'Cerrar Sesión',
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.user != null && (_originalUser == null || state.user! != _originalUser!)) {
              _usernameController.text = state.user!.username ?? '';
              _phoneController.text = state.user!.telefono ?? '';
              _emailController.text = state.user!.correo ?? '';
              _currentUserId = state.user!.id;
              
              // Muestra el mensaje de éxito solo si hay un usuario original con el que comparar
              if (_originalUser != null) {
                  _showMessage('Perfil actualizado con éxito.', Colors.green);
              }
              _originalUser = state.user;
            }
          } else if (state is ProfileError) {
            _showMessage('Error:', Colors.red);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading && _originalUser == null) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (state is ProfileError && _originalUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error al cargar el perfil.', style: GoogleFonts.poppins()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileBloc>().add(ProfileGetEvent()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          final user = _originalUser; // Usamos el usuario cacheado para evitar parpadeos
          if (user == null) {
            return Center(child: Text('No se encontró el perfil.', style: GoogleFonts.poppins()));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                HeaderCard(user: user),
                const SizedBox(height: 24),
                Text(
                  'Datos de Contacto',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        EditableProfileField(
                          label: 'Nombre de usuario',
                          controller: _usernameController,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        EditableProfileField(
                           label: 'Teléfono de contacto',
                           controller: _phoneController,
                           icon: Icons.phone_outlined,
                           keyboardType: TextInputType.phone,
                         ),
                        const SizedBox(height: 16),
                        EditableProfileField(
                          label: 'Correo electrónico',
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    onPressed: () => _showConfirmationDialog(context, user),
                    child: Text(
                      'Guardar Cambios',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// WIDGETS PERSONALIZADOS PARA ESTA VISTA

class HeaderCard extends StatelessWidget {
  final UserModel user;
  const HeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Card(
      elevation: 0,
      color: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: primaryColor,
              child: Icon(Icons.person, color: Colors.white, size: 35),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DNI: ${user.dni}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  const EditableProfileField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}