import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Icon? suffixIcon;
  final bool enabled;
  final TextEditingController? controller; // Nuevo: Controlador
  final String? Function(String?)? validator; // Nuevo: Validador

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.enabled = true,
    this.controller, // Incluir en el constructor
    this.validator, // Incluir en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Inter')),
        const SizedBox(height: 6),
        // **IMPORTANTE**: Cambiar TextField por TextFormField
        // TextFormField es el widget que soporta 'controller' y 'validator'
        TextFormField(
          controller: controller, // Asignar el controlador
          obscureText: obscureText,
          keyboardType: keyboardType, // Ahora sí se usará este parámetro
          validator: validator, // Asignar el validador
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: suffixIcon,
            enabled: enabled, // También pasar 'enabled' si lo necesitas
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}