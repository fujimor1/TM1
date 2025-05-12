import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Profile/Profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static String name = '/Profile';

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}