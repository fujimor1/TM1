import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';

class PaymmentView extends StatelessWidget {
  const PaymmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Text(
                          'IMAGEN',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'El precio de tu suscripción',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text.rich(
                    TextSpan(
                      text: 'Hola Rodolfo, el precio de tu suscripción al ',
                      children: [
                        TextSpan(
                          text: 'Plan Clásico',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' de Ayuda Pe por un mes.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontFamily: 'Inter'
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Precio del plan:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'S/. 30.00',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  label: const Text(
                    'Pagar ahora',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.push('/Pcard');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}