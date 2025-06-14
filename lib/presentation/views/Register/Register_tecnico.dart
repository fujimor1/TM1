import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/views/Register/register_tecnico_second.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/presentation/bloc/services_locator.dart';
import 'package:tm1/presentation/bloc/register/register_cubit.dart';

class RegisterTecnico extends StatefulWidget {
  const RegisterTecnico({super.key});
  static String name = '/RTecnico';

  @override
  State<RegisterTecnico> createState() => _RegisterTecnicoState();
}

class _RegisterTecnicoState extends State<RegisterTecnico> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final registerCubit = getIt<RegisterCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Técnico',
          style: TextStyle(fontFamily: 'PatuaOne'),
        ),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: registerCubit,
        listener: (context, state) {
          if (state is RegisterLoading) {
            debugPrint('Estado: RegisterLoading');
          } else if (state is RegisterLoaded) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Técnico registrado exitosamente!')),
            );
            final userModel = state.userModel;
            debugPrint('Navegando a RSTecnico con ID: ${userModel.id}');

            context.pushNamed(RegisterTecnicoSecond.name, pathParameters: {'id': userModel.id.toString()} );
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Error al registrar técnico. Intenta nuevamente.',
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                CustomTextField(
                  label: 'Nombres',
                  hintText: 'Ingresar nombres',
                  controller: _namesController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Por favor ingresa tus nombres'
                              : null,
                ),
                CustomTextField(
                  label: 'Apellidos',
                  hintText: 'Ingresar apellidos',
                  controller: _lastNamesController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Por favor ingresa tus apellidos'
                              : null,
                ),
                CustomTextField(
                  label: 'Usuario',
                  hintText: 'Ingresar usuario',
                  controller: _usernameController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Por favor ingresa un nombre de usuario'
                              : null,
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
                  keyboardType: TextInputType.number,
                  controller: _dniController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu DNI';
                    }
                    if (value.length != 8) {
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
                CustomTextField(
                  label: 'Teléfono',
                  hintText: 'Ingresar número de celular',
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      final newUser = UserModel(
                        username: _usernameController.text,
                        correo: _emailController.text,
                        password: _passwordController.text,
                        passwordConfirm: _confirmPasswordController.text,
                        firstName: _namesController.text,
                        lastName: _lastNamesController.text,
                        dni: _dniController.text,
                        telefono: _phoneController.text,
                        tipo: 'tecnico',
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
                      borderRadius: BorderRadius.circular(10),
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
                        'Siguiente',
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
    );
  }
}
