// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/presentation/bloc/services_locator.dart';
// import 'package:tm1/presentation/widgets/CustomTextField.dart';
// import 'package:tm1/data/model/user/user_model.dart'; // Importar UserModel
// import 'package:tm1/presentation/bloc/register/register_cubit.dart';

// class RegisterUser extends StatefulWidget {
//   const RegisterUser({super.key});

//   static String name = '/RUser';

//   @override
//   State<RegisterUser> createState() => _RegisterUserState();
// }

// class _RegisterUserState extends State<RegisterUser> {
//   // GlobalKey para el formulario
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _namesController = TextEditingController();
//   final TextEditingController _lastNamesController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _dniController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void dispose() {
//     // Limpiar los controladores cuando el widget se destruye
//     _namesController.dispose();
//     _lastNamesController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _dniController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     final registerCubit = getIt<RegisterCubit>(); 

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Registro de Usuario',
//           style: TextStyle(fontFamily: 'PatuaOne'),
//         ),
//       ),
//       // Usar BlocListener para reaccionar a los estados del Cubit
//       body: BlocListener<RegisterCubit, RegisterState>(
//         bloc: registerCubit, // Asignar el cubit

//         listener: (context, state) {
//           if (state is RegisterLoading) {
//             debugPrint('Estado: RegisterLoading');
//             // ...
//           } else if (state is RegisterLoaded) {
//             debugPrint(
//               'Estado: RegisterLoaded - Usuario: ${state.userModel.username}',
//             );
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Usuario registrado exitosamente!')),
//             );
//             context.go('/login_screen');
//           } else if (state is RegisterError) {
//             debugPrint('Estado: RegisterError');
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Error al registrar usuario. Por favor, inténtalo de nuevo.',
//                 ),
//               ),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey, 
//               child: Column(
//                 children: [
//                   CustomTextField(
//                     label: 'Nombres',
//                     hintText: 'Ingresar nombres',
//                     controller: _namesController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa tus nombres';
//                       }
//                       if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                         return 'El nombre solo puede contener letras';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'Apellidos',
//                     hintText: 'Ingresar apellidos',
//                     controller: _lastNamesController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa tus apellidos';
//                       }
//                       if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                         return 'El nombre solo puede contener letras';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'Usuario',
//                     hintText: 'Ingresar usuario',
//                     controller: _usernameController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa un nombre de usuario';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'Contraseña',
//                     hintText: 'Ingresar contraseña',
//                     obscureText: true,
//                     suffixIcon: const Icon(Icons.visibility),
//                     controller: _passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa una contraseña';
//                       }
//                       if (value.length < 6) {
//                         // Ejemplo de validación mínima
//                         return 'La contraseña debe tener al menos 6 caracteres';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'Repetir contraseña',
//                     hintText: 'Repetir contraseña',
//                     obscureText: true,
//                     suffixIcon: const Icon(Icons.visibility),
//                     controller: _confirmPasswordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor repite tu contraseña';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Las contraseñas no coinciden';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'DNI',
//                     hintText: 'Ingresar documento de identidad',
//                     controller: _dniController,
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa tu DNI';
//                       }
//                       if (value.length != 8) {
//                         // Ejemplo de validación para DNI peruano
//                         return 'El DNI debe tener 8 dígitos';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     label: 'Correo electrónico',
//                     hintText: 'Ingresar correo electrónico',
//                     keyboardType: TextInputType.emailAddress,
//                     controller: _emailController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingresa tu correo electrónico';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Ingresa un correo electrónico válido';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState?.validate() == true) {
//                         // Si el formulario es válido, crear el UserModel
//                         final newUser = UserModel(
//                           username: _usernameController.text,
//                           correo: _emailController.text,
//                           password: _passwordController.text,
//                           passwordConfirm: _confirmPasswordController.text,
//                           firstName: _namesController.text,
//                           lastName: _lastNamesController.text,
//                           dni: _dniController.text,
//                           telefono:
//                               null, 
//                           tipo: 'cliente', 
//                         );
//                         registerCubit.insertUser(newUser);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: BlocBuilder<RegisterCubit, RegisterState>(
//                       bloc: registerCubit,
//                       builder: (context, state) {
//                         if (state is RegisterLoading) {
//                           return const CircularProgressIndicator(
//                             color: Colors.white,
//                           );
//                         }
//                         return const Text(
//                           'Crear cuenta',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/presentation/bloc/services_locator.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/presentation/bloc/register/register_cubit.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});
  static String name = '/RUser';

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  // --- TODA TU LÓGICA ORIGINAL SE MANTIENE INTACTA ---
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _namesController.dispose();
    _lastNamesController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  // --- FIN DE LA LÓGICA ORIGINAL ---

  @override
  Widget build(BuildContext context) {
    final registerCubit = getIt<RegisterCubit>();
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Registro de Cliente', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: registerCubit,
        // TU LISTENER ORIGINAL SIN CAMBIOS
        listener: (context, state) {
          if (state is RegisterLoading) {
            debugPrint('Estado: RegisterLoading');
          } else if (state is RegisterLoaded) {
            debugPrint('Estado: RegisterLoaded - Usuario: ${state.userModel.username}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario registrado exitosamente!'), backgroundColor: Colors.green),
            );
            context.go('/login_screen');
          } else if (state is RegisterError) {
            debugPrint('Estado: RegisterError');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al registrar usuario. Por favor, inténtalo de nuevo.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Padding para el botón
                child: Column(
                  children: [
                    // --- INICIO DE LA NUEVA UI ---
                    // Card de Información Personal
                    _buildSectionCard(
                      title: 'Información Personal',
                      children: [
                        _buildTextField(
                          label: 'Nombres',
                          controller: _namesController,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor ingresa tus nombres';
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'El nombre solo puede contener letras';
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Apellidos',
                          controller: _lastNamesController,
                          icon: Icons.person_outline,
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor ingresa tus apellidos';
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'El apellido solo puede contener letras';
                            return null;
                          },
                        ),
                         _buildTextField(
                          label: 'DNI',
                          controller: _dniController,
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.number,
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor ingresa tu DNI';
                            if (value.length != 8) return 'El DNI debe tener 8 dígitos';
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Card de Datos de la Cuenta
                    _buildSectionCard(
                      title: 'Datos de la Cuenta',
                      children: [
                        _buildTextField(
                          label: 'Nombre de usuario',
                          controller: _usernameController,
                          icon: Icons.account_circle_outlined,
                          validator: (value) => value!.isEmpty ? 'Por favor ingresa un nombre de usuario' : null,
                        ),
                        _buildTextField(
                          label: 'Correo electrónico',
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor ingresa tu correo electrónico';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Ingresa un correo electrónico válido';
                            return null;
                          },
                        ),
                         _buildTextField(
                          label: 'Contraseña',
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor ingresa una contraseña';
                            if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                            return null;
                          },
                        ),
                         _buildTextField(
                          label: 'Confirmar contraseña',
                          controller: _confirmPasswordController,
                          icon: Icons.lock_outline,
                          obscureText: !_isConfirmPasswordVisible,
                           suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                          ),
                           validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor repite tu contraseña';
                            if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                            return null;
                          },
                        ),
                      ],
                    ),
                    // --- FIN DE LA NUEVA UI ---
                  ],
                ),
              ),
            ),
             // Botón de acción fijo
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: BlocBuilder<RegisterCubit, RegisterState>(
                  bloc: registerCubit,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is RegisterLoading ? null : () {
                        if (_formKey.currentState?.validate() == true) {
                          final newUser = UserModel(
                            username: _usernameController.text,
                            correo: _emailController.text,
                            password: _passwordController.text,
                            passwordConfirm: _confirmPasswordController.text,
                            firstName: _namesController.text,
                            lastName: _lastNamesController.text,
                            dni: _dniController.text,
                            telefono: null,
                            tipo: 'cliente',
                          );
                          registerCubit.insertUser(newUser);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: state is RegisterLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'Crear cuenta',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
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

  // --- WIDGETS AUXILIARES DE DISEÑO ---
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
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
            ...children.map((child) => Padding(padding: const EdgeInsets.only(top: 8), child: child)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          decoration: _inputDecoration().copyWith(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
       errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}