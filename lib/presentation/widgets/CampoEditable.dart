import 'package:flutter/material.dart';

class CampoEditable extends StatelessWidget {
  final String label;
  final String initialValue;

  const CampoEditable({
    super.key,
    required this.label,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: initialValue,
            border: const UnderlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
