import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Home/home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String name = '/Home';

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}