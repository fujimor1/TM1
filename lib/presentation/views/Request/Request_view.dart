import 'package:flutter/material.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class RequestView extends StatelessWidget {
  const RequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 2),
      body: Container(

      ),
    );
  }
}