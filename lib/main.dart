import 'package:flutter/material.dart';
import 'package:tm1/config/router/app_router.dart';
import 'package:tm1/config/sharedpreferences/shared_preferences.dart';
// import 'package:tm1/presentation/screens/auth/Login_screen.dart';

void main() async{

  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title:'Proyecto_moviles',
    );
  }
}