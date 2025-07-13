// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class CustomBottomNaviationBar extends StatelessWidget {
//   const CustomBottomNaviationBar({super.key, required this.currentIndex});

//   final int currentIndex;

//   void onItemTaped(BuildContext context, int index){
//     switch (index) {
//       case 0:
//         context.go('/Home');
//         break;
//       case 1:
//         context.go('/Request');
//         break;
//       case 2:
//         context.go('/Profile');
//         break;
//       // case 3:
//       //   context.go('');
//       //   break;
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

class CustomBottomNaviationBar extends StatelessWidget {
  const CustomBottomNaviationBar({super.key, required this.currentIndex});

  final int currentIndex;

  void onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/Home');
        break;
      case 1:
        context.go('/Request');
        break;
      case 2:
        context.go('/Profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // Se reduce el margen vertical para que esté más pegado abajo
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Container(
          // Se reduce el padding vertical interno para bajar la altura
          padding: const EdgeInsets.symmetric(vertical: 8),
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
        onTap: () => onItemTapped(context, index),
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // Se reduce el padding del círculo del ícono
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
            // Se reduce el espacio entre el ícono y el texto
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