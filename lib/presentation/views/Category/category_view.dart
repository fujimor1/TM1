import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORIA', style: TextStyle(fontFamily: 'PatuaOne', fontSize: 30)),
        centerTitle: true,
      ),
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                  context.push('/Cprofile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'CERRAJERO',
                  style: TextStyle(
                    fontFamily: 'PatuaOne',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'ELECTRICISTA',
                  style: TextStyle(
                    fontFamily: 'PatuaOne',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'GASFITERIA',
                  style: TextStyle(
                    fontFamily: 'PatuaOne',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}