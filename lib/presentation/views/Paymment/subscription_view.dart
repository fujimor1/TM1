import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});
  static String name = '/Pcard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('asds'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              context.push('/HVtecnico');
            }, 
            child: Text('Siguiente')
          
          )
        ],
      ),
    );
  }
}