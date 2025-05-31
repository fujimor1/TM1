import 'package:flutter/material.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

class HomeViewTecnico extends StatelessWidget {
  const HomeViewTecnico({super.key});
  static String name = '/HVtecnico';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 0),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 250),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(width: 200, height: 50, color: Colors.black),
                        const SizedBox(height: 25),
                        const Text(
                          'Cualquier consulta puede comunicarse al siguiente número',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsLight'
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'XXX - XXX - XXX',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CB8B8),
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Text(
                          'TÚ ERES\nNUESTRA\nPRIORIDAD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3A3A2C),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
