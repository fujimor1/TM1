import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Paymment/subscription_view.dart';

class PaymmentScreen extends StatelessWidget {
  const PaymmentScreen({super.key});
  static String name = '/Paymment';

  @override
  Widget build(BuildContext context) {
    return SubscriptionView();
  }
}