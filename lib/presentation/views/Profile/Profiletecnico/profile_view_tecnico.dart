import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';

class ProfileViewTecnico extends StatefulWidget {
  const ProfileViewTecnico({super.key});

  static String name = '/Ptecnico';

  @override
  State<ProfileViewTecnico> createState() => _ProfileViewTecnicoState();
}

class _ProfileViewTecnicoState extends State<ProfileViewTecnico> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _currentUserId;
  UserModel? _originalUser; 
  TecnicoModel? _currentTecnico;

  final List<String> seleccionadas = [];
  String? distritoSeleccionado;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileGetEvent());
    context.read<CategoriesCubit>().getCategories();
    context.read<DistrictCubit>().getDistricts();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void toggleCategoria(String categoria) {
    setState(() {
      if (seleccionadas.contains(categoria)) {
        seleccionadas.remove(categoria);
      } else {
        if (seleccionadas.length < 3) {
          seleccionadas.add(categoria);
        } else {
          _showMessage('Solo puedes seleccionar hasta 3 categorías', Colors.orange);
        }
      }
    });
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    if (_currentUserId == null) {
      _showMessage('No se pudo obtener la información de usuario para guardar.', Colors.red);
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Actualización de Perfil'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea guardar los cambios en su perfil?'),
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
                _performSaveChanges();
              },
            ),
          ],
        );
      },
    );
  }

  void _performSaveChanges() {
    final Map<String, dynamic> userUpdatedData = {};

    if (_originalUser != null) {
      if (_usernameController.text != (_originalUser!.username ?? '')) {
        userUpdatedData['username'] = _usernameController.text;
      }
      if (_phoneController.text != (_originalUser!.telefono ?? '')) {
        userUpdatedData['telefono'] = _phoneController.text.isNotEmpty ? _phoneController.text : null;
      }
      if (_emailController.text != (_originalUser!.correo ?? '')) {
        userUpdatedData['correo'] = _emailController.text.isNotEmpty ? _emailController.text : null;
      }
    } else {
      _showMessage('Error: Datos de usuario original no disponibles.', Colors.red);
      return;
    }

    if (userUpdatedData.isEmpty) {
      _showMessage('No hay cambios en los datos de contacto para guardar.', Colors.orange);
      return;
    }

    if (_currentUserId != null) {
      context.read<ProfileBloc>().add(
        ProfilePatchEvent(userUpdatedData, _currentUserId!),
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
    final tecnicoBloc = context.read<TecnicoBloc>();

    return Scaffold(
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 3),
      appBar: AppBar(
        title: const Text(
          'Datos Socio Chambea Ya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: () {
                context.go('/login_screen');
              },
              icon: const Icon(Icons.logout, color: Colors.teal),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded && state.user != null) {
                _currentUserId = state.user!.id;
                if (_originalUser == null || state.user! != _originalUser!) {
                   _usernameController.text = state.user!.username ?? '';
                   _phoneController.text = state.user!.telefono ?? '';
                   _emailController.text = state.user!.correo ?? '';
                }

                _originalUser = state.user;

                if (_currentUserId != null) {
                  tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
                }

              } else if (state is ProfileError) {
                _showMessage('Error al obtener el ID de usuario o cargar/actualizar datos de contacto.', Colors.red);
              }
            },
          ),
          BlocListener<TecnicoBloc, TecnicoState>(
            listener: (context, state) {
              if (state is TecnicoLoaded && state.tecnico != null) {
                _currentTecnico = state.tecnico;
                if (seleccionadas.isEmpty && state.tecnico!.categorias.isNotEmpty) {
                  seleccionadas.addAll(state.tecnico!.categorias.map((c) => c.nombre).whereType<String>());
                }
                if (distritoSeleccionado == null && state.tecnico!.distritos.isNotEmpty) {
                  distritoSeleccionado = state.tecnico!.distritos.first.nombre;
                }

              } else if (state is TecnicoError) {
                _showMessage('Error al cargar datos específicos del técnico.', Colors.red);
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) => current is ProfileLoaded || current is ProfileError,
            listener: (context, state) {
              if (state is ProfileLoaded && _originalUser != null && state.user!.id == _originalUser!.id) {
                _showMessage('¡Perfil de usuario actualizado con éxito!', Colors.green);
              } 
            },
          ),
        ],
        child: BlocBuilder<TecnicoBloc, TecnicoState>(
          builder: (context, tecnicoState) {
            final profileState = context.watch<ProfileBloc>().state;
            UserModel? user;
            if (profileState is ProfileLoaded) {
              user = profileState.user;
            }

            if (tecnicoState is TecnicoLoading || profileState is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tecnicoState is TecnicoError || profileState is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ha ocurrido un error al cargar el perfil. Por favor, reintente.'),
                    ElevatedButton(
                      onPressed: () {
                        profileBloc.add(ProfileGetEvent());
                        if (_currentUserId != null) {
                          tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
                        }
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (tecnicoState is TecnicoLoaded && user != null && tecnicoState.tecnico != null) {
              final tecnico = tecnicoState.tecnico!;

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
                        DatoPerfil(label: 'Apellidos', value: user.lastName),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DatoPerfil(label: 'N° DNI', value: user.dni),
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
                    const SizedBox(height: 20),

                    const Text(
                      'Selecciona tu distrito:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<DistrictCubit, DistrictState>(
                      builder: (context, state) {
                        if (state is DistrictLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is DistrictLoaded) {
                          final distritos = state.district.map((e) => e['nombre']).whereType<String>().toList();

                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            hint: const Text('Selecciona un distrito'),
                            value: distritoSeleccionado ?? (tecnico.distritos.isNotEmpty ? tecnico.distritos.first.nombre : null), // Se corrigió para acceder a 'nombre' directamente
                            items: distritos.map((d) {
                              return DropdownMenuItem<String>(
                                value: d,
                                child: Text(d),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                distritoSeleccionado = value;
                              });
                            },
                          );
                        } else if (state is DistrictError) {
                          return const Text('Error al cargar distritos');
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Selecciona hasta 3 categorías:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<CategoriesCubit, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is CategoriesLoaded) {
                          // Tu código original para categorías
                          final categorias = state.categories;

                          return GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.5,
                            physics: const NeverScrollableScrollPhysics(),
                            children: categorias.map((cat) {
                              final nombre = cat['nombre'] ?? ''; 
                              return CategoriaSelector(
                                nombre: nombre,
                                estaSeleccionado: seleccionadas.contains(nombre) || (tecnico.categorias.any((tc) => tc.nombre == nombre) && !seleccionadas.contains(nombre)), // Se corrigió para acceder a 'nombre' directamente
                                onTap: () => toggleCategoria(nombre),
                              );
                            }).toList(),
                          );
                        } else if (state is CategoriesError) {
                          return const Text('Error al cargar categorías');
                        } else {
                          return const Text('Categorías no disponibles');
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    /// BOTÓN GUARDAR
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _showConfirmationDialog(context);
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
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            return const Center(child: Text('Cargando perfil...'));
          },
        ),
      ),
    );
  }
}

