import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';

class CategoryProfileEdit extends StatelessWidget {
  const CategoryProfileEdit({super.key});
  static String name = '/Cprofile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil',
          style: TextStyle(
            fontFamily: 'PatuaOne',
            fontSize: 30  
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descripción',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xFFF2F2F6),
              ),
              child: const Text(
                'Experiencia en instalación, mantenimiento y reparación de sistemas de plomería y gas.', 
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar foto'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black, 
                  side: const BorderSide(color: Colors.grey), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Center(
              child: Text(
                'Máximo 10 imágenes',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                  },
                ),
                Container(
                  width: 220.0,
                  height: 220.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 48.0,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {

                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEB3223),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text(
                  'Eliminar foto', 
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text(
                  'Guardar Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}