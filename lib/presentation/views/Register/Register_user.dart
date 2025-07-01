import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/bloc/services_locator.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';
import 'package:tm1/data/model/user/user_model.dart'; // Importar UserModel
import 'package:tm1/presentation/bloc/register/register_cubit.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  static String name = '/RUser';

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  // GlobalKey para el formulario
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Limpiar los controladores cuando el widget se destruye
    _namesController.dispose();
    _lastNamesController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final registerCubit = getIt<RegisterCubit>(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(fontFamily: 'PatuaOne'),
        ),
      ),
      // Usar BlocListener para reaccionar a los estados del Cubit
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: registerCubit, // Asignar el cubit

        listener: (context, state) {
          if (state is RegisterLoading) {
            debugPrint('Estado: RegisterLoading');
            // ...
          } else if (state is RegisterLoaded) {
            debugPrint(
              'Estado: RegisterLoaded - Usuario: ${state.userModel.username}',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario registrado exitosamente!')),
            );
            context.go('/login_screen');
          } else if (state is RegisterError) {
            debugPrint('Estado: RegisterError');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Error al registrar usuario. Por favor, inténtalo de nuevo.',
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, 
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nombres',
                    hintText: 'Ingresar nombres',
                    controller: _namesController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tus nombres';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'El nombre solo puede contener letras';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Apellidos',
                    hintText: 'Ingresar apellidos',
                    controller: _lastNamesController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tus apellidos';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'El nombre solo puede contener letras';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Usuario',
                    hintText: 'Ingresar usuario',
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre de usuario';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Contraseña',
                    hintText: 'Ingresar contraseña',
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una contraseña';
                      }
                      if (value.length < 6) {
                        // Ejemplo de validación mínima
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Repetir contraseña',
                    hintText: 'Repetir contraseña',
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor repite tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'DNI',
                    hintText: 'Ingresar documento de identidad',
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu DNI';
                      }
                      if (value.length != 8) {
                        // Ejemplo de validación para DNI peruano
                        return 'El DNI debe tener 8 dígitos';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Correo electrónico',
                    hintText: 'Ingresar correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        // Si el formulario es válido, crear el UserModel
                        final newUser = UserModel(
                          username: _usernameController.text,
                          correo: _emailController.text,
                          password: _passwordController.text,
                          passwordConfirm: _confirmPasswordController.text,
                          firstName: _namesController.text,
                          lastName: _lastNamesController.text,
                          dni: _dniController.text,
                          telefono:
                              null, 
                          tipo: 'cliente', 
                        );
                        registerCubit.insertUser(newUser);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: BlocBuilder<RegisterCubit, RegisterState>(
                      bloc: registerCubit,
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
