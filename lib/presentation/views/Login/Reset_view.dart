import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/widgets/CustomTextField.dart';

class ResetView extends StatelessWidget {
  const ResetView({super.key});

  static String name = '/Reset';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(
              'Reestablecer contrasenia',
              style: TextStyle(
                fontFamily: 'PatuaOne',
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextField(
                  label: 'DNI', 
                  hintText: 'Ingresar documento de identidad'
                  ),
                CustomTextField(
                  label: 'Usuario',
                  hintText: 'Ingresar usuario',
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: (){
              context.push('/RPassword');
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            child: Text('Reestablecer contrasenia',
              style: TextStyle(
                color: Colors.white,
                // fontFamily: 'PatuaOne',
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            )
          ),
          const SizedBox(height: 10,),
         Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                child: Image.asset('assets/images/ResetPassword.jpg'),
              ),
          ),
        ],
      ),
    );
  }
}
