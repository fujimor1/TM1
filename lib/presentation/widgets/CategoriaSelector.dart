import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';

class CategoriaSelector extends StatelessWidget {
  final String nombre;
  final bool estaSeleccionado;
  final VoidCallback onTap;

  const CategoriaSelector({
    super.key,
    required this.nombre,
    required this.estaSeleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: estaSeleccionado ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          nombre,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: estaSeleccionado ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
