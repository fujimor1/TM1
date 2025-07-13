// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';
// import 'package:tm1/data/model/user/user_model.dart';
// import 'package:tm1/data/model/tecnico/tecnico_model.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
// import 'package:tm1/presentation/bloc/district/district_cubit.dart';
// import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
// import 'package:tm1/presentation/widgets/Widgets.dart';

// class ProfileViewTecnico extends StatefulWidget {
//   const ProfileViewTecnico({super.key});

//   static String name = '/Ptecnico';

//   @override
//   State<ProfileViewTecnico> createState() => _ProfileViewTecnicoState();
// }

// class _ProfileViewTecnicoState extends State<ProfileViewTecnico> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   int? _currentUserId;
//   UserModel? _originalUser; 
//   TecnicoModel? _currentTecnico;

//   final List<String> seleccionadas = [];
//   String? distritoSeleccionado;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//     context.read<CategoriesCubit>().getCategories();
//     context.read<DistrictCubit>().getDistricts();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void toggleCategoria(String categoria) {
//     setState(() {
//       if (seleccionadas.contains(categoria)) {
//         seleccionadas.remove(categoria);
//       } else {
//         if (seleccionadas.length < 3) {
//           seleccionadas.add(categoria);
//         } else {
//           _showMessage('Solo puedes seleccionar hasta 3 categorías', Colors.orange);
//         }
//       }
//     });
//   }

//   Future<void> _showConfirmationDialog(BuildContext context) async {
//     if (_currentUserId == null) {
//       _showMessage('No se pudo obtener la información de usuario para guardar.', Colors.red);
//       return;
//     }

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
//                 _performSaveChanges();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performSaveChanges() {
//     final Map<String, dynamic> userUpdatedData = {};

//     if (_originalUser != null) {
//       if (_usernameController.text != (_originalUser!.username ?? '')) {
//         userUpdatedData['username'] = _usernameController.text;
//       }
//       if (_phoneController.text != (_originalUser!.telefono ?? '')) {
//         userUpdatedData['telefono'] = _phoneController.text.isNotEmpty ? _phoneController.text : null;
//       }
//       if (_emailController.text != (_originalUser!.correo ?? '')) {
//         userUpdatedData['correo'] = _emailController.text.isNotEmpty ? _emailController.text : null;
//       }
//     } else {
//       _showMessage('Error: Datos de usuario original no disponibles.', Colors.red);
//       return;
//     }

//     if (userUpdatedData.isEmpty) {
//       _showMessage('No hay cambios en los datos de contacto para guardar.', Colors.orange);
//       return;
//     }

//     if (_currentUserId != null) {
//       context.read<ProfileBloc>().add(
//         ProfilePatchEvent(userUpdatedData, _currentUserId!),
//       );
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
//     final tecnicoBloc = context.read<TecnicoBloc>();

//     return Scaffold(
//       bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 3),
//       appBar: AppBar(
//         title: const Text(
//           'Datos Socio Chambea Ya',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: IconButton(
//               onPressed: () {
//                 context.go('/login_screen');
//               },
//               icon: const Icon(Icons.logout, color: Colors.teal),
//             ),
//           ),
//         ],
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<ProfileBloc, ProfileState>(
//             listener: (context, state) {
//               if (state is ProfileLoaded && state.user != null) {
//                 _currentUserId = state.user!.id;
//                 if (_originalUser == null || state.user! != _originalUser!) {
//                    _usernameController.text = state.user!.username ?? '';
//                    _phoneController.text = state.user!.telefono ?? '';
//                    _emailController.text = state.user!.correo ?? '';
//                 }

//                 _originalUser = state.user;

//                 if (_currentUserId != null) {
//                   tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
//                 }

//               } else if (state is ProfileError) {
//                 _showMessage('Error al obtener el ID de usuario o cargar/actualizar datos de contacto.', Colors.red);
//               }
//             },
//           ),
//           BlocListener<TecnicoBloc, TecnicoState>(
//             listener: (context, state) {
//               if (state is TecnicoLoaded && state.tecnico != null) {
//                 _currentTecnico = state.tecnico;
//                 if (seleccionadas.isEmpty && state.tecnico!.categorias.isNotEmpty) {
//                   seleccionadas.addAll(state.tecnico!.categorias.map((c) => c.nombre).whereType<String>());
//                 }
//                 if (distritoSeleccionado == null && state.tecnico!.distritos.isNotEmpty) {
//                   distritoSeleccionado = state.tecnico!.distritos.first.nombre;
//                 }

//               } else if (state is TecnicoError) {
//                 _showMessage('Error al cargar datos específicos del técnico.', Colors.red);
//               }
//             },
//           ),
//           BlocListener<ProfileBloc, ProfileState>(
//             listenWhen: (previous, current) => current is ProfileLoaded || current is ProfileError,
//             listener: (context, state) {
//               if (state is ProfileLoaded && _originalUser != null && state.user!.id == _originalUser!.id) {
//                 _showMessage('¡Perfil de usuario actualizado con éxito!', Colors.green);
//               } 
//             },
//           ),
//         ],
//         child: BlocBuilder<TecnicoBloc, TecnicoState>(
//           builder: (context, tecnicoState) {
//             final profileState = context.watch<ProfileBloc>().state;
//             UserModel? user;
//             if (profileState is ProfileLoaded) {
//               user = profileState.user;
//             }

//             if (tecnicoState is TecnicoLoading || profileState is ProfileLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (tecnicoState is TecnicoError || profileState is ProfileError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Ha ocurrido un error al cargar el perfil. Por favor, reintente.'),
//                     ElevatedButton(
//                       onPressed: () {
//                         profileBloc.add(ProfileGetEvent());
//                         if (_currentUserId != null) {
//                           tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
//                         }
//                       },
//                       child: const Text('Reintentar'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (tecnicoState is TecnicoLoaded && user != null && tecnicoState.tecnico != null) {
//               final tecnico = tecnicoState.tecnico!;

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         DatoPerfil(label: 'Nombres', value: user.firstName),
//                         DatoPerfil(label: 'Apellidos', value: user.lastName),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     DatoPerfil(label: 'N° DNI', value: user.dni),
//                     const SizedBox(height: 30),
//                     const Text(
//                       'Datos de Contacto',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     CampoEditable(
//                       label: 'Nombre de usuario',
//                       controller: _usernameController,
//                       keyboardType: TextInputType.text,
//                     ),
//                     CampoEditable(
//                       label: 'Teléfono de contacto',
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                     ),
//                     CampoEditable(
//                       label: 'Correo electrónico',
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 20),

//                     const Text(
//                       'Selecciona tu distrito:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     BlocBuilder<DistrictCubit, DistrictState>(
//                       builder: (context, state) {
//                         if (state is DistrictLoading) {
//                           return const Center(child: CircularProgressIndicator());
//                         } else if (state is DistrictLoaded) {
//                           final distritos = state.district.map((e) => e['nombre']).whereType<String>().toList();

//                           return DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                             ),
//                             hint: const Text('Selecciona un distrito'),
//                             value: distritoSeleccionado ?? (tecnico.distritos.isNotEmpty ? tecnico.distritos.first.nombre : null), // Se corrigió para acceder a 'nombre' directamente
//                             items: distritos.map((d) {
//                               return DropdownMenuItem<String>(
//                                 value: d,
//                                 child: Text(d),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 distritoSeleccionado = value;
//                               });
//                             },
//                           );
//                         } else if (state is DistrictError) {
//                           return const Text('Error al cargar distritos');
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     const Text(
//                       'Selecciona hasta 3 categorías:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     BlocBuilder<CategoriesCubit, CategoriesState>(
//                       builder: (context, state) {
//                         if (state is CategoriesLoading) {
//                           return const Center(child: CircularProgressIndicator());
//                         } else if (state is CategoriesLoaded) {
//                           // Tu código original para categorías
//                           final categorias = state.categories;

//                           return GridView.count(
//                             crossAxisCount: 3,
//                             shrinkWrap: true,
//                             mainAxisSpacing: 12,
//                             crossAxisSpacing: 12,
//                             childAspectRatio: 2.5,
//                             physics: const NeverScrollableScrollPhysics(),
//                             children: categorias.map((cat) {
//                               final nombre = cat['nombre'] ?? ''; 
//                               return CategoriaSelector(
//                                 nombre: nombre,
//                                 estaSeleccionado: seleccionadas.contains(nombre) || (tecnico.categorias.any((tc) => tc.nombre == nombre) && !seleccionadas.contains(nombre)), // Se corrigió para acceder a 'nombre' directamente
//                                 onTap: () => toggleCategoria(nombre),
//                               );
//                             }).toList(),
//                           );
//                         } else if (state is CategoriesError) {
//                           return const Text('Error al cargar categorías');
//                         } else {
//                           return const Text('Categorías no disponibles');
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     /// BOTÓN GUARDAR
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () {
//                           _showConfirmationDialog(context);
//                         },
//                         child: const Text(
//                           'Guardar Datos',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               );
//             }

//             return const Center(child: Text('Cargando perfil...'));
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tm1/data/model/user/user_model.dart';
// import 'package:tm1/data/model/tecnico/tecnico_model.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
// import 'package:tm1/presentation/bloc/district/district_cubit.dart';
// import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

// class ProfileViewTecnico extends StatefulWidget {
//   const ProfileViewTecnico({super.key});
//   static String name = '/Ptecnico';

//   @override
//   State<ProfileViewTecnico> createState() => _ProfileViewTecnicoState();
// }

// class _ProfileViewTecnicoState extends State<ProfileViewTecnico> {
//   // --- TODA TU LÓGICA ORIGINAL SE MANTIENE INTACTA ---
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   int? _currentUserId;
//   UserModel? _originalUser;
//   TecnicoModel? _currentTecnico;

//   final List<String> seleccionadas = [];
//   String? distritoSeleccionado;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//     context.read<CategoriesCubit>().getCategories();
//     context.read<DistrictCubit>().getDistricts();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void toggleCategoria(String categoria) {
//     setState(() {
//       if (seleccionadas.contains(categoria)) {
//         seleccionadas.remove(categoria);
//       } else {
//         if (seleccionadas.length < 3) {
//           seleccionadas.add(categoria);
//         } else {
//           _showMessage('Solo puedes seleccionar hasta 3 categorías', Colors.orange);
//         }
//       }
//     });
//   }

//   Future<void> _showConfirmationDialog(BuildContext context) async {
//     if (_currentUserId == null) {
//       _showMessage('No se pudo obtener la información de usuario para guardar.', Colors.red);
//       return;
//     }
    
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Text('Confirmar Cambios', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//           content: Text('¿Desea guardar los cambios en su perfil?', style: GoogleFonts.poppins()),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No', style: GoogleFonts.poppins(color: Colors.grey[700])),
//               onPressed: () => Navigator.of(dialogContext).pop(),
//             ),
//             TextButton(
//               child: Text('Sí, Guardar', style: GoogleFonts.poppins(color: const Color(0xFF56A3A6), fontWeight: FontWeight.bold)),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _performSaveChanges();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _performSaveChanges() {
//     final Map<String, dynamic> userUpdatedData = {};

//     if (_originalUser != null) {
//       if (_usernameController.text != (_originalUser!.username ?? '')) {
//         userUpdatedData['username'] = _usernameController.text;
//       }
//       if (_phoneController.text != (_originalUser!.telefono ?? '')) {
//         userUpdatedData['telefono'] = _phoneController.text.isNotEmpty ? _phoneController.text : null;
//       }
//       if (_emailController.text != (_originalUser!.correo ?? '')) {
//         userUpdatedData['correo'] = _emailController.text.isNotEmpty ? _emailController.text : null;
//       }
//     } else {
//       _showMessage('Error: Datos de usuario original no disponibles.', Colors.red);
//       return;
//     }

//     if (userUpdatedData.isEmpty) {
//       _showMessage('No hay cambios en los datos de contacto para guardar.', Colors.orange);
//       return;
//     }

//     if (_currentUserId != null) {
//       context.read<ProfileBloc>().add(
//         ProfilePatchEvent(userUpdatedData, _currentUserId!),
//       );
//     } else {
//       _showMessage('Error: ID de usuario no disponible para actualizar.', Colors.red);
//     }
//   }

//   void _showMessage(String message, Color color) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: GoogleFonts.poppins()),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // --- NUEVO MÉTODO PARA MOSTRAR EL MODAL DE DISTRITOS (COMO ANTES) ---
//   void _showDistrictFilter() {
//     final districtCubit = context.read<DistrictCubit>();
//     if (districtCubit.state is! DistrictLoaded) return;

//     final districts = (districtCubit.state as DistrictLoaded).district;

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Selecciona tu Distrito',
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//               const Divider(height: 1),
//               Flexible(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: districts.length,
//                   itemBuilder: (context, index) {
//                     final district = districts[index];
//                     final districtName = district['nombre'] as String;
//                     return ListTile(
//                       title: Text(districtName, style: GoogleFonts.poppins()),
//                       onTap: () {
//                         setState(() {
//                           distritoSeleccionado = districtName;
//                         });
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   // --- FIN DE LA LÓGICA ORIGINAL Y NUEVO MÉTODO ---

//   @override
//   Widget build(BuildContext context) {
//     final profileBloc = context.read<ProfileBloc>();
//     final tecnicoBloc = context.read<TecnicoBloc>();
//     const primaryColor = Color(0xFF56A3A6);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 3),
//       appBar: AppBar(
//         title: Text('Mi Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
//         actions: [
//           IconButton(
//             onPressed: () => context.go('/login_screen'),
//             icon: const Icon(Icons.logout_outlined, color: Colors.black54),
//             tooltip: 'Cerrar Sesión',
//           ),
//           const SizedBox(width: 8),
//         ],
//         centerTitle: true,
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//       ),
//       body: MultiBlocListener(
//         listeners: [
//           // TUS BLOCLISTENERS ORIGINALES SIN CAMBIOS
//           BlocListener<ProfileBloc, ProfileState>(
//              listener: (context, state) {
//                if (state is ProfileLoaded && state.user != null) {
//                  _currentUserId = state.user!.id;
//                  if (_originalUser == null || state.user! != _originalUser!) {
//                     _usernameController.text = state.user!.username ?? '';
//                     _phoneController.text = state.user!.telefono ?? '';
//                     _emailController.text = state.user!.correo ?? '';
//                  }
//                  _originalUser = state.user;
//                  if (_currentUserId != null) {
//                    tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
//                  }
//                } else if (state is ProfileError) {
//                  _showMessage('Error al obtener el ID de usuario o cargar/actualizar datos de contacto.', Colors.red);
//                }
//              },
//            ),
//            BlocListener<TecnicoBloc, TecnicoState>(
//              listener: (context, state) {
//                if (state is TecnicoLoaded && state.tecnico != null) {
//                  _currentTecnico = state.tecnico;
//                  if (seleccionadas.isEmpty && state.tecnico!.categorias.isNotEmpty) {
//                    seleccionadas.addAll(state.tecnico!.categorias.map((c) => c.nombre).whereType<String>());
//                  }
//                  if (distritoSeleccionado == null && state.tecnico!.distritos.isNotEmpty) {
//                    distritoSeleccionado = state.tecnico!.distritos.first.nombre;
//                  }
//                } else if (state is TecnicoError) {
//                  _showMessage('Error al cargar datos específicos del técnico.', Colors.red);
//                }
//              },
//            ),
//            BlocListener<ProfileBloc, ProfileState>(
//              listenWhen: (previous, current) => current is ProfileLoaded || current is ProfileError,
//              listener: (context, state) {
//                if (state is ProfileLoaded && _originalUser != null && state.user!.id == _originalUser!.id) {
//                  _showMessage('¡Perfil de usuario actualizado con éxito!', Colors.green);
//                }
//              },
//            ),
//         ],
//         child: BlocBuilder<TecnicoBloc, TecnicoState>(
//           builder: (context, tecnicoState) {
//             final profileState = context.watch<ProfileBloc>().state;
//             UserModel? user;
//             if (profileState is ProfileLoaded) {
//               user = profileState.user;
//             }

//             if (tecnicoState is TecnicoLoading || profileState is ProfileLoading) {
//               return const Center(child: CircularProgressIndicator(color: primaryColor));
//             }

//             if (tecnicoState is TecnicoError || profileState is ProfileError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Ha ocurrido un error al cargar el perfil. Por favor, reintente.'),
//                     ElevatedButton(
//                       onPressed: () {
//                         profileBloc.add(ProfileGetEvent());
//                         if (_currentUserId != null) {
//                           tecnicoBloc.add(GetTecnicoByIdEvent(_currentUserId!));
//                         }
//                       },
//                       child: const Text('Reintentar'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (tecnicoState is TecnicoLoaded && user != null && tecnicoState.tecnico != null) {
//               // --- INICIO DE LA NUEVA UI ---
//               return Stack(
//                 children: [
//                   SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _HeaderCard(user: user),
//                         const SizedBox(height: 24),
//                         _SectionTitle(title: 'Datos de Contacto'),
//                         const SizedBox(height: 16),
//                         Card(
//                           elevation: 0,
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 _EditableProfileField(label: 'Nombre de usuario', controller: _usernameController, icon: Icons.person_outline),
//                                 const SizedBox(height: 16),
//                                 _EditableProfileField(label: 'Teléfono de contacto', controller: _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
//                                 const SizedBox(height: 16),
//                                 _EditableProfileField(label: 'Correo electrónico', controller: _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         _SectionTitle(title: 'Área de Trabajo'),
//                         const SizedBox(height: 16),
//                         Card(
//                            elevation: 0,
//                            color: Colors.white,
//                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                            child: Padding(
//                              padding: const EdgeInsets.all(16.0),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text('Distrito de Cobertura', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
//                                  const SizedBox(height: 8),
//                                  // --- CAMBIO: BOTÓN PARA ABRIR MODAL DE DISTRITO ---
//                                  OutlinedButton(
//                                    onPressed: _showDistrictFilter,
//                                    style: OutlinedButton.styleFrom(
//                                      foregroundColor: Colors.black87,
//                                      backgroundColor: Colors.white,
//                                      side: BorderSide(color: Colors.grey.shade300),
//                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                                    ),
//                                    child: Row(
//                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                      children: [
//                                        Text(distritoSeleccionado ?? 'Seleccionar distrito', style: GoogleFonts.poppins()),
//                                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//                                      ],
//                                    ),
//                                  ),
//                                  const SizedBox(height: 20),
//                                  Text('Categorías (máx. 3)', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
//                                  const SizedBox(height: 12),
//                                  // --- CAMBIO: GRIDVIEW PARA CATEGORÍAS ---
//                                  BlocBuilder<CategoriesCubit, CategoriesState>(
//                                    builder: (context, state) {
//                                      if (state is CategoriesLoaded) {
//                                        return GridView.builder(
//                                          shrinkWrap: true,
//                                          physics: const NeverScrollableScrollPhysics(),
//                                          itemCount: state.categories.length,
//                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                            crossAxisCount: 3,
//                                            childAspectRatio: 2.5,
//                                            mainAxisSpacing: 8,
//                                            crossAxisSpacing: 8,
//                                          ),
//                                          itemBuilder: (context, index) {
//                                             final cat = state.categories[index];
//                                             final nombre = cat['nombre'] ?? '';
//                                             return ChoiceChip(
//                                               label: Text(nombre, style: GoogleFonts.poppins(fontSize: 12)),
//                                               selected: seleccionadas.contains(nombre),
//                                               onSelected: (bool selected) => toggleCategoria(nombre),
//                                               selectedColor: primaryColor.withOpacity(0.2),
//                                               side: BorderSide(color: seleccionadas.contains(nombre) ? primaryColor : Colors.grey.shade300),
//                                               showCheckmark: false,
//                                             );
//                                          },
//                                        );
//                                      }
//                                      return const Center(child: CircularProgressIndicator());
//                                    },
//                                  ),
//                                ],
//                              ),
//                            ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => _showConfirmationDialog(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 2,
//                         ),
//                         child: Text(
//                           'Guardar Cambios',
//                           style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             }

//             return const Center(child: Text('Cargando perfil...'));
//           },
//         ),
//       ),
//     );
//   }
// }

// // --- WIDGETS AUXILIARES PARA EL NUEVO DISEÑO ---

// class _HeaderCard extends StatelessWidget {
//   final UserModel user;
//   const _HeaderCard({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF56A3A6);
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         color: primaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 30,
//             backgroundColor: primaryColor,
//             child: Icon(Icons.person, color: Colors.white, size: 35),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${user.firstName} ${user.lastName}',
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'DNI: ${user.dni}',
//                   style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 18),
//     );
//   }
// }

// class _EditableProfileField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final IconData icon;
//   final TextInputType keyboardType;

//   const _EditableProfileField({
//     required this.label,
//     required this.controller,
//     required this.icon,
//     this.keyboardType = TextInputType.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
//           decoration: _inputDecoration().copyWith(prefixIcon: Icon(icon, color: Colors.grey[500])),
//         ),
//       ],
//     );
//   }
// }

// InputDecoration _inputDecoration() {
//   return InputDecoration(
//     filled: true,
//     fillColor: Colors.white,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey.shade300),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey.shade300),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Color(0xFF56A3A6), width: 2),
//     ),
//   );
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/views/pdf/pdf_viewer_screen.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';


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
  
  // --- INICIO: CÓDIGO PARA PDF ---
  /// Carga el PDF desde los assets, lo copia a un directorio temporal y
  /// navega a la pantalla del visor de PDF.
  Future<void> _openLocalPdf(BuildContext context) async {
    const assetPath = 'assets/Manualdeusuario.pdf';

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/temp_pdf.pdf");

      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(localPath: file.path),
          ),
        );
      }
    } catch (e) {
      _showMessage('Error al abrir el documento: $e', Colors.red);
    }
  }
  // --- FIN: CÓDIGO PARA PDF ---

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirmar Cambios', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text('¿Desea guardar los cambios en su perfil?', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: GoogleFonts.poppins(color: Colors.grey[700])),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Sí, Guardar', style: GoogleFonts.poppins(color: const Color(0xFF56A3A6), fontWeight: FontWeight.bold)),
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDistrictFilter() {
    final districtCubit = context.read<DistrictCubit>();
    if (districtCubit.state is! DistrictLoaded) return;

    final districts = (districtCubit.state as DistrictLoaded).district;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selecciona tu Distrito',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
                    final districtName = district['nombre'] as String;
                    return ListTile(
                      title: Text(districtName, style: GoogleFonts.poppins()),
                      onTap: () {
                        setState(() {
                          distritoSeleccionado = districtName;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // --- INICIO: CÓDIGO PARA PDF ---
  /// Construye el widget del enlace para abrir el PDF.
  Widget _buildTermsAndConditionsLink(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => _openLocalPdf(context),
        icon: const Icon(Icons.info_outline, color: Colors.black54),
        label: Text(
          'Términos y Condiciones del Servicio',
          style: GoogleFonts.poppins(
            color: Colors.black54,
            decoration: TextDecoration.underline,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  // --- FIN: CÓDIGO PARA PDF ---

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    final tecnicoBloc = context.read<TecnicoBloc>();
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 3),
      appBar: AppBar(
        title: Text('Mi Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
        actions: [
          IconButton(
            onPressed: () => context.go('/login_screen'),
            icon: const Icon(Icons.logout_outlined, color: Colors.black54),
            tooltip: 'Cerrar Sesión',
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
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
              return const Center(child: CircularProgressIndicator(color: primaryColor));
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
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), // Padding inferior aumentado
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeaderCard(user: user),
                        const SizedBox(height: 24),
                        _SectionTitle(title: 'Datos de Contacto'),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _EditableProfileField(label: 'Nombre de usuario', controller: _usernameController, icon: Icons.person_outline),
                                const SizedBox(height: 16),
                                _EditableProfileField(label: 'Teléfono de contacto', controller: _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                                const SizedBox(height: 16),
                                _EditableProfileField(label: 'Correo electrónico', controller: _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _SectionTitle(title: 'Área de Trabajo'),
                        const SizedBox(height: 16),
                        Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Distrito de Cobertura', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
                                  const SizedBox(height: 8),
                                  OutlinedButton(
                                    onPressed: _showDistrictFilter,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.grey.shade300),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(distritoSeleccionado ?? 'Seleccionar distrito', style: GoogleFonts.poppins()),
                                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text('Categorías (máx. 3)', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
                                  const SizedBox(height: 12),
                                  BlocBuilder<CategoriesCubit, CategoriesState>(
                                    builder: (context, state) {
                                      if (state is CategoriesLoaded) {
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: state.categories.length,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2.5,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                          ),
                                          itemBuilder: (context, index) {
                                            final cat = state.categories[index];
                                            final nombre = cat['nombre'] ?? '';
                                            return ChoiceChip(
                                              label: Text(nombre, style: GoogleFonts.poppins(fontSize: 12)),
                                              selected: seleccionadas.contains(nombre),
                                              onSelected: (bool selected) => toggleCategoria(nombre),
                                              selectedColor: primaryColor.withOpacity(0.2),
                                              side: BorderSide(color: seleccionadas.contains(nombre) ? primaryColor : Colors.grey.shade300),
                                              showCheckmark: false,
                                            );
                                          },
                                        );
                                      }
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ),
                        
                        // --- INICIO: WIDGET DEL LINK AL PDF ---
                        const SizedBox(height: 24),
                        _buildTermsAndConditionsLink(context),
                        // --- FIN: WIDGET DEL LINK AL PDF ---

                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: Text(
                          'Guardar Cambios',
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

            return const Center(child: Text('Cargando perfil...'));
          },
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES (SIN CAMBIOS) ---

class _HeaderCard extends StatelessWidget {
  final UserModel user;
  const _HeaderCard({required this.user});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'DNI: ${user.dni}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 18),
    );
  }
}

class _EditableProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  const _EditableProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          decoration: _inputDecoration().copyWith(prefixIcon: Icon(icon, color: Colors.grey[500])),
        ),
      ],
    );
  }
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
  );
}