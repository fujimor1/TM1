import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/config/theme/app_colors.dart'; 

// Importa tus Cubit y States
import 'package:tm1/presentation/bloc/login/login_cubit.dart'; 


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(DioClient()),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250,
              child: Image.asset(
                'assets/images/Background.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 200,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            'assets/images/Logo.png',
                          ),
                          const SizedBox(height: 30),
                          TextField( 
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField( 
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 320,
                            child: BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state is LoginSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('¡Inicio de sesión exitoso!')),
                                  );
                                  context.go('/Paymment'); 
                                } else if (state is LoginError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error al iniciar sesión. Por favor, verifica tus credenciales o inténtalo más tarde.')),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is LoginLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(color: AppColors.primary),
                                  );
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<LoginCubit>(context).login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(color: AppColors.buttoncolor),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    context.push('/Register');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'No tengo cuenta',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              context.push('/Reset');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '¿Olvidó su contraseña?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}