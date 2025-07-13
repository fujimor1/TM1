// import 'package:flutter/material.dart';
// import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

// class HomeViewTecnico extends StatelessWidget {
//   const HomeViewTecnico({super.key});
//   static String name = '/HVtecnico';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 0),
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: 300,
//             child: Image.asset(
//               'assets/images/Background.png',
//               fit: BoxFit.cover,
//             ),
//           ),

//           Column(
//             children: [
//               const SizedBox(height: 250),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(25.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         // Container(width: 200, height: 50, color: Colors.black),
//                         Image.asset('assets/images/BannerChambea.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(height: 25),
//                         const Text(
//                           'Cualquier consulta puede comunicarse al siguiente número',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'PoppinsLight'
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         const Text(
//                           'XXX - XXX - XXX',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF4CB8B8),
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         const Text(
//                           'TÚ ERES\nNUESTRA\nPRIORIDAD',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.w900,
//                             color: Color(0xFF3A3A2C),
//                             height: 1.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

class HomeViewTecnico extends StatefulWidget {
  const HomeViewTecnico({super.key});
  static String name = '/HVtecnico';

  @override
  State<HomeViewTecnico> createState() => _HomeViewTecnicoState();
}

class _HomeViewTecnicoState extends State<HomeViewTecnico> {
  @override
  void initState() {
    super.initState();
    // Se añade el evento para cargar los datos del perfil
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 0),
      appBar: AppBar(
        toolbarHeight: 0, // Ocultamos el AppBar por defecto
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabecera de Bienvenida ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String userName = 'Socio'; // Nombre por defecto
                  if (state is ProfileLoaded) {
                    userName = state.user?.firstName ?? 'Socio';
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola de nuevo,',
                        style: GoogleFonts.poppins(fontSize: 20, color: Colors.grey[600]),
                      ),
                      Text(
                        '$userName!',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // --- Banner Promocional ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                clipBehavior: Clip.antiAlias, // Para que la imagen respete los bordes redondeados
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                child: Image.asset(
                  'assets/images/BannerChambea.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Tarjeta de Soporte ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildInfoCard(
                icon: Icons.support_agent,
                iconColor: primaryColor,
                title: 'Soporte al Socio',
                child: Column(
                  children: [
                    Text(
                      'Para cualquier consulta, puedes comunicarte al siguiente número:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.grey[700], height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        '987 - 654 - 321',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Eslogan ---
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'TÚ ERES\nNUESTRA\nPRIORIDAD',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3A3A2C).withOpacity(0.8),
                    height: 1.3,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear tarjetas de información
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            child,
          ],
        ),
      ),
    );
  }
}