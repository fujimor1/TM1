import 'package:flutter/material.dart';

class SolicitudCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;

  const SolicitudCard({
    super.key,
    required this.child,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenido principal
          Expanded(child: child),
          // Botón de cerrar
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, size: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
