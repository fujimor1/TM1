import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class HomeView extends StatelessWidget {
  final List<Map<String, dynamic>> categorias = [
    {'nombre': 'Cerrajero', 'icono': 'assets/images/Contaco.png'},
    {'nombre': 'Electricista', 'icono': 'assets/images/Contaco.png'},
    {'nombre': 'Electrónico', 'icono': 'assets/images/Contaco.png'},
    {'nombre': 'Gasfitero', 'icono': 'assets/images/Contaco.png'},
    {'nombre': 'Mecánico', 'icono': 'assets/images/Contaco.png'},
    {'nombre': 'Técnico', 'icono': 'assets/images/Contaco.png'},
  ];

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 0),
      appBar: AppBar(
        title: Center(
          child: Text(
            'CATEGORIAS',
            style: TextStyle(
              fontFamily: 'PatuaOne',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: categorias.map((cat) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed('/TecnicosView', pathParameters: {'categoria': cat['nombre']});
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: const BoxDecoration(
                              color: Color(0xFF5FB7B7),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              cat['icono'],
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['nombre'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}