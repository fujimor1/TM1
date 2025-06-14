// import 'package:flutter/material.dart';

// class CampoEditable extends StatelessWidget {
//   final String label;
//   final String? initialValue; 

//   const CampoEditable({
//     Key? key,
//     required this.label,
//     required this.initialValue, 
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(height: 4),
//         TextFormField(
//           initialValue: initialValue ?? '', // <--- Usa el operador ?? para un string vacío si es nulo
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: Colors.grey[200],
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           ),
//           readOnly: true,
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
// }

// // class CampoEditable extends StatelessWidget {
// //   final String label;
// //   final String initialValue;
// //   final TextEditingController controller;

// //   const CampoEditable({
// //     super.key,
// //     required this.label,
// //     required this.initialValue,
// //     required this.controller,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     controller.text = initialValue;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
// //         const SizedBox(height: 6),
// //         TextFormField(
// //           controller: controller,
// //           decoration: const InputDecoration(
// //             border: OutlineInputBorder(),
// //           ),
// //         ),
// //         const SizedBox(height: 12),
// //       ],
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';

// class CampoEditable extends StatelessWidget {
//   final String label;
//   final TextEditingController? controller; // Ahora acepta un TextEditingController
//   final TextInputType keyboardType; // Añadido para flexibilidad del tipo de teclado

//   const CampoEditable({
//     super.key,
//     required this.label,
//     required this.controller, // El controlador es ahora requerido
//     this.keyboardType = TextInputType.text, // Valor por defecto
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(height: 4),
//         TextFormField(
//           controller: controller, // Asignamos el controlador
//           keyboardType: keyboardType, // Asignamos el tipo de teclado
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: Colors.grey[200],
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           ),
//           readOnly: false, // ¡Ahora es editable!
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class CampoEditable extends StatelessWidget {
  final String label;
  final TextEditingController? controller; // Ahora es opcional
  final String? initialValue; // Mantenemos initialValue, también opcional
  final TextInputType keyboardType;

  const CampoEditable({
    Key? key,
    required this.label,
    this.controller, // Ya no es requerido
    this.initialValue, // Opcional
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina si el campo es de solo lectura (no se proporciona un controller)
    final bool isReadOnly = controller == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller, // Se usa si se proporciona, de lo contrario es null
          initialValue: isReadOnly ? initialValue ?? '' : null, // Solo usa initialValue si es de solo lectura
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          readOnly: isReadOnly, // Controla si es editable o no
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}