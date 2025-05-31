import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Custombottomnavigationbartecnico extends StatelessWidget {
  const Custombottomnavigationbartecnico({super.key, required this.currentIndex});

  final int currentIndex;

  void onItemTaped(BuildContext context, int index){
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
          icon: Icon(Icons.manage_accounts),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        )
      ],

    );
  }
}