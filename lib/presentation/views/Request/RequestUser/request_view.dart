import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/widgets/Widgets.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';

class RequestView extends StatefulWidget {
  static const String name = '/requests';

  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SolicitudBloc())],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MIS SOLICITUDES',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'PatuaOne',
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: const CustomBottomNaviationBar(currentIndex: 1),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, profileState) {
              if (profileState is ProfileLoaded && profileState.user != null) {
                print('Profile Loaded - User ID: ${profileState.user!.id}');
                context.read<SolicitudBloc>().add(
                  GetSolicitudesByClientEvent(profileState.user!.id!),
                );
              } else if (profileState is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error al cargar los datos del usuario para sus solicitudes.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<SolicitudBloc, SolicitudState>(
              builder: (context, solicitudState) {
                if (solicitudState is SolicitudesByClientLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (solicitudState is SolicitudesByClientLoaded) {
                  if (solicitudState.solicitudes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tienes solicitudes registradas.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: solicitudState.solicitudes.length,
                    itemBuilder: (context, index) {
                      final SolicitudModel solicitud =
                          solicitudState.solicitudes[index];
                      final String estado = solicitud.estado;
                      final String titulo = solicitud.titulo;
                      return SolicitudCard(
                        onClose: () {
                          print(
                            'Intentando eliminar solicitud: ${solicitud.id}',
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87),
                                children: [
                                  const TextSpan(text: 'Estado: '),
                                  TextSpan(
                                    text: estado,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (estado == 'ACEPTADO') ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildContactButton(
                                    icon: FontAwesomeIcons.whatsapp,
                                    text: 'Contactar WhatsApp',
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildContactButton(
                                    icon: FontAwesomeIcons.solidEnvelope,
                                    text: 'Contactar Email',
                                    color: Colors.red,
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
                                    print(
                                      'Marcando solicitud ${solicitud.id} como FINALIZADA',
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
                  );
                } else if (solicitudState is SolicitudError) {
                  return Center(
                    child: Text(
                      'Error al cargar solicitudes: ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }
                // Estado inicial o cualquier otro estado no manejado
                return const Center(child: Text('Cargando solicitudes...'));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
