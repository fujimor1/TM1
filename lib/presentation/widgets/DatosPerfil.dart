import 'package:flutter/material.dart';

class DatoPerfil extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const DatoPerfil({
    super.key,
    required this.label,
    required this.value,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
