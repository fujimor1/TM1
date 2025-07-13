// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class Custombottomnavigationbartecnico extends StatelessWidget {
//   const Custombottomnavigationbartecnico({super.key, required this.currentIndex});

//   final int currentIndex;

//   void onItemTaped(BuildContext context, int index){
//     switch (index) {
//       case 0:
//         context.go('/HVtecnico');
//         break;
//       case 1:
//         context.go('/RVtecnico');
//         break;
//       case 2:
//         context.go('/Category');
//         break;
//       case 3:
//         context.go('/Ptecnico');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       elevation: 0,
//       useLegacyColorScheme: false,
//       onTap: (value) => onItemTaped(context, value),
//       items: const[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home,),
//           label: 'Inicio',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.mail),
//           label: 'Notificaciones',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.manage_accounts),
//           label: 'Perfil',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Perfil',
//         )
//       ],

//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Custombottomnavigationbartecnico extends StatelessWidget {
  const Custombottomnavigationbartecnico({super.key, required this.currentIndex});

  final int currentIndex;

  void onItemTaped(BuildContext context, int index) {
    // Tu lógica original sin cambios
    switch (index) {
      case 0:
        context.go('/HVtecnico');
        break;
      case 1:
        context.go('/RVtecnico');
        break;
      case 2:
        context.go('/Category');
        break;
      case 3:
        context.go('/Ptecnico');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // Margen para dar el efecto flotante
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                label: 'Inicio',
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                label: 'Solicitudes',
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                label: 'Categorías',
                icon: Icons.category_outlined,
                activeIcon: Icons.category,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                label: 'Perfil',
                icon: Icons.person_outline,
                activeIcon: Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper para construir cada item de la barra
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    const primaryColor = Color(0xFF56A3A6);
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTaped(context, index),
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? primaryColor : Colors.grey[600],
                size: 26,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? primaryColor : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}