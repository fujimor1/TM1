// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/config/theme/app_colors.dart';

// class RegisterView extends StatelessWidget {
//   const RegisterView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   const Text(
//                     'CREAR CUENTA',
//                     style: TextStyle(
//                       fontFamily: 'PatuaOne',
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.push('/RUser');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 100,
//                         vertical: 10,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'USUARIO',
//                       style: TextStyle(
//                         fontFamily: 'PatuaOne',
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.push('/RTecnico');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 100,
//                         vertical: 10,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'TÉCNICO',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'PatuaOne',
//                         fontSize: 30,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   Image.asset('assets/images/Tools.png'),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF56A3A6);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Añadimos un botón para volver a la pantalla anterior
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crear una cuenta',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Elige el tipo de perfil que mejor se adapte a ti.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              
              // Tarjeta para el rol de Cliente
              _buildRoleCard(
                context: context,
                icon: Icons.person_search_outlined,
                title: 'Soy Cliente',
                subtitle: 'Busco un profesional para un servicio.',
                color: primaryColor,
                onTap: () => context.push('/RUser'),
              ),
              const SizedBox(height: 24),

              // Tarjeta para el rol de Técnico
              _buildRoleCard(
                context: context,
                icon: Icons.construction_outlined,
                title: 'Soy Técnico',
                subtitle: 'Ofrezco mis servicios profesionales.',
                color: primaryColor,
                onTap: () => context.push('/RTecnico'),
              ),
              const Spacer(), // Empuja el contenido hacia el centro si hay espacio extra
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir las tarjetas de selección de rol
  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}