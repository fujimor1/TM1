import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/config/theme/app_colors.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/widgets/CustombottomNavigationBarTecnico.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

class RequestViewTecnico extends StatefulWidget {
  static const String name = '/RVtecnico';

  const RequestViewTecnico({super.key});

  @override
  State<RequestViewTecnico> createState() => _RequestViewTecnicoState();
}

class _RequestViewTecnicoState extends State<RequestViewTecnico> {
  String _selectedEstado = 'Todas';
  String _selectedCategoria = 'Todas';

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SolicitudBloc()),
        BlocProvider(create: (context) => TecnicoBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: const Custombottomnavigationbartecnico(
          currentIndex: 1,
        ),
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
                _buildFilterButton(
                  'Estado',
                  _selectedEstado,
                  ['Todas', 'pendiente', 'aceptado', 'rechazado', 'Finalizado'],
                  (value) {
                    setState(() {
                      _selectedEstado = value;
                      _filterRequests(context);
                    });
                  },
                ),
                const SizedBox(width: 20),
                BlocBuilder<TecnicoBloc, TecnicoState>(
                  builder: (context, tecnicoState) {
                    List<String> categorias = ['Todas'];
                    if (tecnicoState is TecnicoLoaded) {
                      categorias.addAll(
                        tecnicoState.tecnico.categorias.map((c) => c.nombre!),
                      );
                    }
                    return _buildFilterButton(
                      'Categoría',
                      _selectedCategoria,
                      categorias,
                      (value) {
                        setState(() {
                          _selectedCategoria = value;
                          _filterRequests(context);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (context, profileState) {
                  if (profileState is ProfileLoaded &&
                      profileState.user != null) {
                    final tecnicoId = profileState.user!.id!;
                    print('Profile Loaded for Tecnico - User ID: $tecnicoId');

                    // Solicitudes del técnico
                    context.read<SolicitudBloc>().add(
                      GetSolicitudesByTecnicoEvent(tecnicoId),
                    );

                    context.read<TecnicoBloc>().add(
                      GetTecnicoByIdEvent(tecnicoId),
                    );
                  } else if (profileState is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error al cargar los datos del técnico para sus solicitudes.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<SolicitudBloc, SolicitudState>(
                  builder: (context, solicitudState) {
                    if (solicitudState is SolicitudesByTecnicoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (solicitudState is SolicitudesByTecnicoLoaded) {
                      final List<SolicitudModel> filteredRequests =
                          _filterSolicitudes(solicitudState.solicitudes);

                      if (filteredRequests.isEmpty) {
                        return const Center(
                          child: Text(
                            'No tienes solicitudes asignadas con los filtros seleccionados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final SolicitudModel request =
                              filteredRequests[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                if (request.estado.toLowerCase() ==
                                    'pendiente') {
                                  context.pushNamed(
                                    '/Rdetails',
                                    extra: request,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Esta solicitud está ${request.estado} y no se puede ver el detalle.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: _buildRequestCard(request),
                            ),
                          );
                        },
                      );
                    } else if (solicitudState is SolicitudError) {
                      return const Center(
                        child: Text(
                          'Error al cargar solicitudes del técnico.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }
                    return const Center(
                      child: Text('Cargando solicitudes del técnico...'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    String selectedValue,
    List<String> items,
    ValueChanged<String> onSelected,
  ) {
    return PopupMenuButton<String>(
      initialValue: selectedValue,
      onSelected: onSelected,
      color: const Color(0xFFE0F2F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder:
          (BuildContext context) =>
              items
                  .map(
                    (item) => PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Color(0xFF424242)),
                      ),
                    ),
                  )
                  .toList(),
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          elevation: 3,
          enabledMouseCursor: MaterialStateMouseCursor.clickable,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildRequestCard(SolicitudModel request) {
    return Container(
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
              Expanded(
                child: Text(
                  request.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Acción para solicitud: ${request.titulo}'),
                    ),
                  );
                },
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF424242),
                  size: 24,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1, color: Colors.grey),
          _buildInfoRow('Cliente:', request.cliente.firstName ?? 'N/A'),
          _buildInfoRow('Categoría:', request.categoria.nombre ?? 'N/A'),
          _buildInfoRow('Dirección:', request.direccion),
          _buildInfoRow('Estado:', request.estado),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<SolicitudModel> _filterSolicitudes(List<SolicitudModel> solicitudes) {
    return solicitudes.where((request) {
      final matchesEstado =
          (_selectedEstado == 'Todas' || request.estado == _selectedEstado);
      final matchesCategoria =
          (_selectedCategoria == 'Todas' ||
              request.categoria.nombre == _selectedCategoria);
      return matchesEstado && matchesCategoria;
    }).toList();
  }

  void _filterRequests(BuildContext context) {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded && profileState.user != null) {
      context.read<SolicitudBloc>().add(
        GetSolicitudesByTecnicoEvent(profileState.user!.id!),
      );
    }
  }
}
