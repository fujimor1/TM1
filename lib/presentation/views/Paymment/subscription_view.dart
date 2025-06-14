import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});
  static String name = '/Pcard';

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF267BFF), Color(0xFF586BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const Text('Pagar', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),

            // Métodos de pago
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF267BFF), Color(0xFF586BFF)],
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    PaymentMethodIcon(asset: Icons.credit_card, label: 'VISA'),
                    PaymentMethodIcon(asset: Icons.credit_card, label: 'MasterCard'),
                    PaymentMethodIcon(asset: Icons.credit_card, label: 'AmEx'),
                    PaymentMethodIcon(asset: Icons.account_balance_wallet, label: 'PayPal'),
                  ],
                ),
              ),
            ),

            // Formulario de pago
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tus datos de pago', style: titleStyle),
                    const SizedBox(height: 12),
                    const CustomTextField(
                      label: 'Titular de la tarjeta',
                      hintText: 'Ej. Rodolfo Rivera',
                    ),
                    const CustomTextField(
                      label: 'Número de la tarjeta',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: const [
                        Expanded(
                          child: CustomTextField(
                            label: 'Fecha de vencimiento',
                            hintText: 'MM/YYYY',
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'CVV',
                            hintText: 'Ej. 123',
                            keyboardType: TextInputType.number,
                            suffixIcon: Icon(Icons.info_outline, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Monto total',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'S/ 30.00 PEN',
                      style: TextStyle(fontSize: 24, color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF54BAB9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.lock, color: Colors.white),
                        label: const Text(
                          'Pagar ahora',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          context.push('/HVtecnico');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodIcon extends StatelessWidget {
  final IconData asset;
  final String label;

  const PaymentMethodIcon({super.key, required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(asset, size: 32, color: Colors.blue),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
