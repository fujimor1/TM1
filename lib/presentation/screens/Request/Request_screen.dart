import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Request/Request_view.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});
  static String name = 'Request';

  @override
  Widget build(BuildContext context) {
    return RequestView();
  }
}