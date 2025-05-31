import 'package:flutter/material.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/presentation/views/Request/RequestTecnico/request_details.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';

class RequestViewTecnico extends StatefulWidget {
  const RequestViewTecnico({super.key});
  static String name = 'RVtecnico';

  @override
  State<RequestViewTecnico> createState() => _RequestViewTecnicoState();
}

class _RequestViewTecnicoState extends State<RequestViewTecnico> {
  String _selectedEstado = 'Todas';
  String _selectedCategoria = 'Todas';

  final List<Map<String, String>> _allRequests = [
    {
      'title': 'LLAVE ATORADA',
      'cliente': 'Luciana Vasquez',
      'categoria': 'Cerrajero',
      'distrito': 'Villa el Salvador',
      'direccion': 'Mz. M St. 3 Gr. 11',
      'estado': 'Pendiente',
      'descripcion': 'Se rompió mi llave y se quedó dentro de la cerradura.', // Añadida descripción para el detalle
      'fotos': 'url_foto1,url_foto2' // Puedes añadir URLs de fotos aquí si las usarás en RequestDetails
    },
    {
      'title': 'FUGAS DE AGUA',
      'cliente': 'Carlos Rivera',
      'categoria': 'Fontanero',
      'distrito': 'Surco',
      'direccion': 'Av. Pardo 123',
      'estado': 'Aceptado',
      'descripcion': 'Fuga de agua en el lavabo de la cocina.',
      'fotos': ''
    },
    {
      'title': 'PROBLEMAS ELÉCTRICOS',
      'cliente': 'Ana Gómez',
      'categoria': 'Electricista',
      'distrito': 'Miraflores',
      'direccion': 'Calle Las Flores 456',
      'estado': 'Pendiente',
      'descripcion': 'Cortocircuito en el enchufe de la sala.',
      'fotos': ''
    },
    {
      'title': 'REPARACIÓN DE TUBERÍAS',
      'cliente': 'Pedro Salas',
      'categoria': 'Fontanero',
      'distrito': 'San Juan de Lurigancho',
      'direccion': 'Jr. Unión 789',
      'estado': 'Rechazado',
      'descripcion': 'Tubería rota en el baño, necesita reemplazo.',
      'fotos': ''
    },
    {
      'title': 'CAMBIO DE CERRADURA',
      'cliente': 'Marta Diaz',
      'categoria': 'Cerrajero',
      'distrito': 'La Molina',
      'direccion': 'Av. Sol 101',
      'estado': 'Aceptado',
      'descripcion': 'Cambio de cerradura de la puerta principal.',
      'fotos': ''
    },
    {
      'title': 'INSTALACIÓN DE LUZ',
      'cliente': 'Roberto Pérez',
      'categoria': 'Electricista',
      'distrito': 'Ate',
      'direccion': 'Av. Principal 202',
      'estado': 'Aceptado',
      'descripcion': 'Instalación de nueva luminaria en el techo.',
      'fotos': ''
    },
    {
      'title': 'DESATORO DE CAÑERÍAS',
      'cliente': 'Sofía Linares',
      'categoria': 'Fontanero',
      'distrito': 'Chorrillos',
      'direccion': 'Calle Mar 303',
      'estado': 'Pendiente',
      'descripcion': 'Cañería de lavadero obstruida, no drena.',
      'fotos': ''
    },
    {
      'title': 'DUPLICADO DE LLAVES',
      'cliente': 'Fernando Castro',
      'categoria': 'Cerrajero',
      'distrito': 'Barranco',
      'direccion': 'Jr. Luna 404',
      'estado': 'Pendiente',
      'descripcion': 'Necesito duplicado de una llave antigua.',
      'fotos': ''
    },
  ];

  List<Map<String, String>> get _filteredRequests {
    return _allRequests.where((request) {
      final matchesEstado = (_selectedEstado == 'Todas' || request['estado'] == _selectedEstado);
      final matchesCategoria = (_selectedCategoria == 'Todas' || request['categoria'] == _selectedCategoria);
      return matchesEstado && matchesCategoria;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Custombottomnavigationbartecnico(currentIndex: 1),
      appBar: AppBar(
        title: const Text(
          'MIS SOLICITUDES',
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
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PopupMenuButton<String>(
                initialValue: _selectedEstado,
                onSelected: (String value) {
                  setState(() {
                    _selectedEstado = value;
                  });
                },
                color: const Color(0xFFE0F2F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Todas',
                    child: Text('Todas', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Pendiente',
                    child: Text('Pendiente', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Aceptado',
                    child: Text('Aceptado', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Rechazado',
                    child: Text('Rechazado', style: TextStyle(color: Color(0xFF424242))),
                  ),
                ],
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    elevation: 3,
                    enabledMouseCursor: MaterialStateMouseCursor.clickable,
                  ),
                  child: const Text(
                    'Estado',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              PopupMenuButton<String>(
                initialValue: _selectedCategoria,
                onSelected: (String value) {
                  setState(() {
                    _selectedCategoria = value;
                  });
                },
                color: const Color(0xFFE0F2F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Todas',
                    child: Text('Todas', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Cerrajero',
                    child: Text('Cerrajero', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Electricista',
                    child: Text('Electricista', style: TextStyle(color: Color(0xFF424242))),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Fontanero',
                    child: Text('Fontanero', style: TextStyle(color: Color(0xFF424242))),
                  ),
                ],
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Manteniendo AppColors.primary para ambos
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    elevation: 3,
                    enabledMouseCursor: MaterialStateMouseCursor.clickable,
                  ),
                  child: const Text(
                    'Categoría',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: _filteredRequests.isEmpty
                ? const Center(
                    child: Text(
                      'No hay solicitudes para mostrar con los filtros seleccionados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = _filteredRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            if (request['estado'] == 'Pendiente') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestDetails(requestData: request),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Esta solicitud está ${request['estado']} y no se puede ver el detalle.')),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F7),
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
                                      request['title']!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF424242),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Eliminar solicitud: ${request['title']}')),
                                        );
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
                                _buildInfoRow('Cliente:', request['cliente']!),
                                _buildInfoRow('Categoría:', request['categoria']!),
                                _buildInfoRow('Distrito:', request['distrito']!),
                                _buildInfoRow('Dirección:', request['direccion']!),
                                _buildInfoRow('Estado:', request['estado']!),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}