// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/presentation/views/Register/register_tecnico_second.dart';
// import 'package:tm1/presentation/widgets/CustomTextField.dart';
// import 'package:tm1/data/model/user/user_model.dart';
// import 'package:tm1/presentation/bloc/services_locator.dart';
// import 'package:tm1/presentation/bloc/register/register_cubit.dart';

// class RegisterTecnico extends StatefulWidget {
//   const RegisterTecnico({super.key});
//   static String name = '/RTecnico';

//   @override
//   State<RegisterTecnico> createState() => _RegisterTecnicoState();
// }

// class _RegisterTecnicoState extends State<RegisterTecnico> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _namesController = TextEditingController();
//   final TextEditingController _lastNamesController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _dniController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   @override
//   void dispose() {
//     _namesController.dispose();
//     _lastNamesController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _dniController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final registerCubit = getIt<RegisterCubit>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Registro de Técnico',
//           style: TextStyle(fontFamily: 'PatuaOne'),
//         ),
//       ),
//       body: BlocListener<RegisterCubit, RegisterState>(
//         bloc: registerCubit,
//         listener: (context, state) {
//           if (state is RegisterLoading) {
//             debugPrint('Estado: RegisterLoading');
//           } else if (state is RegisterLoaded) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Técnico registrado exitosamente!')),
//             );
//             final userModel = state.userModel;
//             debugPrint('Navegando a RSTecnico con ID: ${userModel.id}');

//             context.pushNamed(
//               RegisterTecnicoSecond.name,
//               pathParameters: {'id': userModel.id.toString()},
//             );
//           } else if (state is RegisterError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Error al registrar técnico. Intenta nuevamente.',
//                 ),
//               ),
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 CustomTextField(
//                   label: 'Nombres',
//                   hintText: 'Ingresar nombres',
//                   controller: _namesController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tus nombres';
//                     }
//                     if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                       return 'El nombre solo puede contener letras';
//                     }
//                     return null;
//                   },
//                   // value == null || value.isEmpty
//                   //     ? 'Por favor ingresa tus nombres'
//                   //     : null,
//                 ),
//                 CustomTextField(
//                   label: 'Apellidos',
//                   hintText: 'Ingresar apellidos',
//                   controller: _lastNamesController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tus nombres';
//                     }
//                     if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                       return 'El nombre solo puede contener letras';
//                     }
//                     return null;
//                   },
//                   // value == null || value.isEmpty
//                   //     ? 'Por favor ingresa tus apellidos'
//                   //     : null,
//                 ),
//                 CustomTextField(
//                   label: 'Usuario',
//                   hintText: 'Ingresar usuario',
//                   controller: _usernameController,
//                   validator:
//                       (value) =>
//                           value == null || value.isEmpty
//                               ? 'Por favor ingresa un nombre de usuario'
//                               : null,
//                 ),
//                 CustomTextField(
//                   label: 'Contraseña',
//                   hintText: 'Ingresar contraseña',
//                   obscureText: true,
//                   suffixIcon: const Icon(Icons.visibility),
//                   controller: _passwordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa una contraseña';
//                     }
//                     if (value.length < 6) {
//                       return 'La contraseña debe tener al menos 6 caracteres';
//                     }
//                     return null;
//                   },
//                 ),
//                 CustomTextField(
//                   label: 'Repetir contraseña',
//                   hintText: 'Repetir contraseña',
//                   obscureText: true,
//                   suffixIcon: const Icon(Icons.visibility),
//                   controller: _confirmPasswordController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor repite tu contraseña';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Las contraseñas no coinciden';
//                     }
//                     return null;
//                   },
//                 ),
//                 CustomTextField(
//                   label: 'DNI',
//                   hintText: 'Ingresar documento de identidad',
//                   keyboardType: TextInputType.number,
//                   controller: _dniController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu DNI';
//                     }
//                     if (value.length != 8) {
//                       return 'El DNI debe tener 8 dígitos';
//                     }
//                     return null;
//                   },
//                 ),
//                 CustomTextField(
//                   label: 'Correo electrónico',
//                   hintText: 'Ingresar correo electrónico',
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu correo electrónico';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return 'Ingresa un correo electrónico válido';
//                     }
//                     return null;
//                   },
//                 ),
//                 CustomTextField(
//                   label: 'Teléfono',
//                   hintText: 'Ingresar número de celular',
//                   keyboardType: TextInputType.number,
//                   controller: _phoneController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu número de teléfono';
//                     }
//                     // VALIDACIÓN AÑADIDA: Debe tener exactamente 9 dígitos.
//                     if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
//                       return 'El teléfono debe tener 9 dígitos';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() == true) {
//                       final newUser = UserModel(
//                         username: _usernameController.text,
//                         correo: _emailController.text,
//                         password: _passwordController.text,
//                         passwordConfirm: _confirmPasswordController.text,
//                         firstName: _namesController.text,
//                         lastName: _lastNamesController.text,
//                         dni: _dniController.text,
//                         telefono: _phoneController.text,
//                         tipo: 'tecnico',
//                       );
//                       registerCubit.insertUser(newUser);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: BlocBuilder<RegisterCubit, RegisterState>(
//                     bloc: registerCubit,
//                     builder: (context, state) {
//                       if (state is RegisterLoading) {
//                         return const CircularProgressIndicator(
//                           color: Colors.white,
//                         );
//                       }
//                       return const Text(
//                         'Siguiente',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
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
import 'package:tm1/presentation/views/Register/register_tecnico_second.dart';

class RegisterTecnico extends StatefulWidget {
  const RegisterTecnico({super.key});
  static String name = '/RTecnico';

  @override
  State<RegisterTecnico> createState() => _RegisterTecnicoState();
}

class _RegisterTecnicoState extends State<RegisterTecnico> {
  // --- TODA TU LÓGICA ORIGINAL SE MANTIENE INTACTA ---
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Estados para la visibilidad de la contraseña
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
    _phoneController.dispose();
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
        title: Text('Registro de Socio', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Técnico registrado exitosamente!'), backgroundColor: Colors.green));
            final userModel = state.userModel;
            debugPrint('Navegando a RSTecnico con ID: ${userModel.id}');
            context.pushNamed(
              RegisterTecnicoSecond.name,
              pathParameters: {'id': userModel.id.toString()},
            );
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error al registrar técnico. Intenta nuevamente.'),
              backgroundColor: Colors.red,
            ));
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
                    // Stepper visual
                    _buildStepper(),
                    const SizedBox(height: 24),

                    // Card de Información Personal
                    _buildSectionCard(
                      title: 'Información Personal',
                      children: [
                        _buildTextField(label: 'Nombres', controller: _namesController, icon: Icons.person_outline, validator: (v) => (v!.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) ? 'Ingresa un nombre válido' : null),
                        _buildTextField(label: 'Apellidos', controller: _lastNamesController, icon: Icons.person_outline, validator: (v) => (v!.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) ? 'Ingresa un apellido válido' : null),
                        _buildTextField(label: 'DNI', controller: _dniController, icon: Icons.badge_outlined, keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || v.length != 8) ? 'El DNI debe tener 8 dígitos' : null),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Card de Datos de la Cuenta
                    _buildSectionCard(
                      title: 'Datos de la Cuenta',
                      children: [
                        _buildTextField(label: 'Nombre de usuario', controller: _usernameController, icon: Icons.account_circle_outlined, validator: (v) => v!.isEmpty ? 'Ingresa un nombre de usuario' : null),
                        _buildTextField(label: 'Correo electrónico', controller: _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => (v!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) ? 'Ingresa un correo válido' : null),
                        _buildTextField(label: 'Teléfono', controller: _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || v.length != 9) ? 'El teléfono debe tener 9 dígitos' : null),
                        _buildTextField(label: 'Contraseña', controller: _passwordController, icon: Icons.lock_outline, obscureText: !_isPasswordVisible, suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)), validator: (v) => (v!.isEmpty || v.length < 6) ? 'La contraseña debe tener al menos 6 caracteres' : null),
                        _buildTextField(label: 'Confirmar contraseña', controller: _confirmPasswordController, icon: Icons.lock_outline, obscureText: !_isConfirmPasswordVisible, suffixIcon: IconButton(icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible)), validator: (v) => v != _passwordController.text ? 'Las contraseñas no coinciden' : null),
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
                            username: _usernameController.text, correo: _emailController.text, password: _passwordController.text,
                            passwordConfirm: _confirmPasswordController.text, firstName: _namesController.text, lastName: _lastNamesController.text,
                            dni: _dniController.text, telefono: _phoneController.text, tipo: 'tecnico',
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
                          : Text('Siguiente', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(isActive: true, label: '1', title: 'Datos'),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1.5)),
        _buildStep(isActive: false, label: '2', title: 'Perfil'),
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

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    required String label, required TextEditingController controller, required IconData icon,
    String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text,
    bool obscureText = false, Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, validator: validator, keyboardType: keyboardType, obscureText: obscureText,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          decoration: _inputDecoration().copyWith(prefixIcon: Icon(icon, color: Colors.grey[500]), suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF56A3A6), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }
}