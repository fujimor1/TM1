import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'CREAR CUENTA',
                style: TextStyle(
                  fontFamily: 'PatuaOne',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 40,),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/RUser');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'USUARIO',
                      style: TextStyle(
                        fontFamily: 'PatuaOne',
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/RTecnico');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'TÉCNICO',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PatuaOne',
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Image.asset('assets/images/Tools.png'),
                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Image.asset(
                  //     'assets/images/Tools.png',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}