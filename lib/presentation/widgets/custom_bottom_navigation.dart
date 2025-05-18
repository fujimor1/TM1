import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNaviationBar extends StatelessWidget {
  const CustomBottomNaviationBar({super.key, required this.currentIndex});

  final int currentIndex;

  void onItemTaped(BuildContext context, int index){
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
      // case 3:
      //   context.go('');
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      elevation: 0,
      useLegacyColorScheme: false,
      onTap: (value) => onItemTaped(context, value),
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home,),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        )
      ],

    );
  }
}