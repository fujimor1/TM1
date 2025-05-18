import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tm1/presentation/widgets/SolicitudCard.dart';
import 'package:tm1/presentation/widgets/custom_bottom_navigation.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  List<Map<String, String>> solicitudes = [
    {'titulo': 'LLAVE ATORADA', 'estado': 'Pendiente'},
    {'titulo': 'TUBERÍA ROTA DE BAÑO', 'estado': 'Aceptado'},
    {'titulo': 'TUBERÍA ROTA DE BAÑO', 'estado': 'Rechazado'},
  ];

  void eliminarSolicitud(int index) {
    setState(() {
      solicitudes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIS SOLICITUDES',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: solicitudes.length,
          itemBuilder: (context, index) {
            final solicitud = solicitudes[index];
            final estado = solicitud['estado']!;
            final titulo = solicitud['titulo']!;

            return SolicitudCard(
              onClose: () => eliminarSolicitud(index),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        const TextSpan(text: 'Estado: '),
                        TextSpan(
                          text: estado,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (estado == 'Aceptado') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Contáctame',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              FaIcon( FontAwesomeIcons.google, color: Colors.red, size: 16
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Contáctame',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Solicitud finalizada'),
                            ),
                          );
                        },
                        child: const Text(
                          'FINALIZADO',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
