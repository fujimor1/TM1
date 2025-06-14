import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';

// class DatoPerfil extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const DatoPerfil({
//     super.key,
//     required this.label,
//     required this.value,
//     this.color = AppColors.primary,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(fontWeight: FontWeight.bold, color: color),
//         ),
//       ],
//     );
//   }
// }
class DatoPerfil extends StatelessWidget {
  final String label;
  final String? value; // <--- ¡CAMBIO AQUÍ! Acepta String?
  final Color? color;

  const DatoPerfil({
    Key? key,
    required this.label,
    required this.value, // <--- Este sigue siendo required
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.teal,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? 'N/A', // <--- Usa el operador ?? para mostrar "N/A" si es nulo
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}