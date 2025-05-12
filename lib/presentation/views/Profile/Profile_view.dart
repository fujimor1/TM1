import 'package:flutter/material.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      body: Container(),
    );
  }
}