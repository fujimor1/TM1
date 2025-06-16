import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';

class RequestDetails extends StatelessWidget {
  static String name = '/Rdetails';

  final Map<String, String> requestData;

  const RequestDetails({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle de la Solicitud',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
            fontFamily: 'PatuaOne',
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFE0F2F7,
                  ), // Color de fondo de la tarjeta
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          requestData['title']!, //
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pop(); // Cierra la vista de detalles
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                    _buildInfoRow(
                      'Descripción:',
                      requestData['descripcion'] ?? 'No disponible',
                    ), //
                    const SizedBox(height: 10),
                    const Text(
                      'Fotos:', //
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF424242),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Simulación de fotos (puedes reemplazarlas con Image.network o Image.file)
                    Row(
                      children: [
                        _buildPhotoPlaceholder(), //
                        const SizedBox(width: 10),
                        _buildPhotoPlaceholder(), //
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Cliente:', requestData['cliente']!), //
                    _buildInfoRow('Categoría:', requestData['categoria']!), //
                    _buildInfoRow('Distrito:', requestData['distrito']!), //
                    _buildInfoRow('Dirección:', requestData['direccion']!), //
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Botones de Aceptar y Rechazar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para Aceptar la solicitud
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Solicitud ${requestData['title']} Aceptada',
                            ),
                          ),
                        );
                        Navigator.of(
                          context,
                        ).pop(); // Vuelve a la vista anterior
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary, // Color verde para Aceptar
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Aceptar', //
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para Rechazar la solicitud
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Solicitud ${requestData['title']} Rechazada',
                            ),
                          ),
                        );
                        Navigator.of(
                          context,
                        ).pop(); // Vuelve a la vista anterior
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red[600], // Color rojo para Rechazar
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Rechazar', //
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text.rich(
        TextSpan(
          text: '$label ',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    // Puedes reemplazar esto con Image.network o Image.file
    // Si tienes URLs de imágenes en requestData, úsalas aquí.
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage(
            'assets/placeholder_key.png',
          ), // Reemplaza con tu imagen si la tienes
          fit: BoxFit.cover,
        ),
      ),
      child: const Icon(
        Icons.image,
        color: Colors.grey,
        size: 50,
      ), // Icono de placeholder si no hay imagen
    );
  }
}
