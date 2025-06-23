// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// // 1. Importa el nuevo paquete
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/suscripcion/bloc/subscription_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

// // 2. Definimos una clase para manejar el navegador de Mercado Pago
// // Esto mantiene el código más limpio y organizado.
// class _MercadoPagoBrowser extends InAppBrowser {
//   final BuildContext context;

//   _MercadoPagoBrowser(this.context);
  
//   // Este método se llama cada vez que una página termina de cargar en el in-app browser.
//   @override
//   Future onLoadStop(WebUri? url) async {
//     final urlString = url.toString();

//     // Verificamos si la URL contiene las palabras clave de redirección de Mercado Pago
//     if (urlString.contains('success')) {
//       _showFeedbackAndClose('¡Pago exitoso!', Colors.green);
//     } else if (urlString.contains('failure')) {
//       _showFeedbackAndClose('El pago falló. Por favor, inténtalo de nuevo.', Colors.red);
//     } else if (urlString.contains('pending')) {
//       _showFeedbackAndClose('Tu pago está pendiente de aprobación.', Colors.orange);
//     }
//   }

//   void _showFeedbackAndClose(String message, Color color) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: color),
//       );
//     }
//     // Cierra el navegador
//     close();
//   }
// }


// class SubscriptionView extends StatefulWidget {
//   const SubscriptionView({super.key});
//   static String name = '/Pcard';

//   @override
//   State<SubscriptionView> createState() => _SubscriptionViewState();
// }

// class _SubscriptionViewState extends State<SubscriptionView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(ProfileGetEvent());
//   }

//   // 3. Método para abrir el InAppBrowser (CORREGIDO)
//   Future<void> _openMercadoPagoCheckout(String url) async {
//     final browser = _MercadoPagoBrowser(context);
//     await browser.openUrlRequest(
//       urlRequest: URLRequest(url: WebUri(url)),
//       // Se usa el nuevo parámetro 'settings' con la estructura correcta para la v6
//       settings: InAppBrowserClassSettings(
//         browserSettings: InAppBrowserSettings(
//           // Oculta la barra de URL para que se sienta más como parte de la app
//           hideUrlBar: true, 
//         ),
//         webViewSettings: InAppWebViewSettings(
//           // Permite que se ejecute JavaScript en la página de pago
//           javaScriptEnabled: true,
//         )
//       ),
//     );
//   }

//   void _handlePayment(int tecnicoId) {
//     context
//         .read<SubscriptionBloc>()
//         .add(CreateSubscriptionPreferenceEvent(tecnicoId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<ProfileBloc, ProfileState>(
//           listener: (context, state) {
//             if (state is ProfileLoaded) {
//               final userId = state.user!.id;
//               if (userId != null) {
//                 context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(userId));
//               }
//             }
//           },
//         ),
//         BlocListener<SubscriptionBloc, SubscriptionState>(
//           listener: (context, state) {
//             if (state is SubscriptionPreferenceCreated) {
//               final String? initPoint = state.preferenceData['init_point'] ?? state.preferenceData['sandbox_init_point'];
//               if (initPoint != null) {
//                 // 4. En lugar de navegar, ahora llamamos a nuestra función para abrir el browser
//                 _openMercadoPagoCheckout(initPoint);
//               } else {
//                  ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Error: No se recibió la URL de pago.'), backgroundColor: Colors.red),
//                 );
//               }
//             } else if (state is SubscriptionError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
//               );
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Mi Suscripción', style: TextStyle(fontFamily: 'PatuaOne', fontSize: 28)),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => context.pop(),
//           ),
//         ),
//         body: BlocBuilder<TecnicoBloc, TecnicoState>(
//           builder: (context, tecnicoState) {
//             if (tecnicoState is TecnicoLoading || tecnicoState is TecnicoInitial) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (tecnicoState is TecnicoError) {
//               return const Center(child: Text('Error al cargar los datos del técnico.'));
//             }

//             if (tecnicoState is TecnicoLoaded) {
//               final tecnico = tecnicoState.tecnico;
//               if (tecnico.suscripcionActiva) {
//                 return _buildActiveSubscriptionView(tecnico);
//               } else {
//                 return _buildInactiveSubscriptionView(tecnico.usuario.id!);
//               }
//             }
//             return const Center(child: Text('Cargando información...'));
//           },
//         ),
//       ),
//     );
//   }

//   // Los widgets _buildActiveSubscriptionView y _buildInactiveSubscriptionView
//   // no necesitan cambios y se mantienen como los tenías.
//   Widget _buildActiveSubscriptionView(tecnico) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle, color: Colors.green, size: 80),
//             const SizedBox(height: 20),
//             const Text(
//               '¡Tu suscripción está activa!',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             _buildInfoRow('Fecha de inicio:', tecnico.fechaInicioSuscripcion ?? 'No disponible'),
//             _buildInfoRow('Próximo vencimiento:', tecnico.fechaFinSuscripcion ?? 'No disponible'),
//             const SizedBox(height: 40),
//              ElevatedButton(
//                 onPressed: () => context.pop(),
//                 child: const Text('Volver'),
//               )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInactiveSubscriptionView(int tecnicoId) {
//     final state = context.watch<SubscriptionBloc>().state;
//     final bool isLoading = state is SubscriptionLoading;

//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.credit_card_off, color: Colors.orange, size: 80),
//           const SizedBox(height: 20),
//           const Text(
//             'Renueva tu suscripción',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//              textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Accede a todos los beneficios y contacta con más clientes.',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//           const Spacer(),
//           const Text(
//             'Monto a Pagar:',
//             style: TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'S/ 10.00 PEN', // Precio de tu backend
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               icon: isLoading ? const SizedBox.shrink() : const Icon(Icons.payment, color: Colors.white),
//               label: isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Pagar Suscripción', style: TextStyle(fontSize: 16, color: Colors.white)),
//               onPressed: isLoading ? null : () => _handlePayment(tecnicoId),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//    Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
//           Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }



// lib/presentation/views/subscription_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/suscripcion/bloc/subscription_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});
  static String name = '/Pcard';

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

// 2. Añadimos WidgetsBindingObserver para detectar cuando el usuario vuelve a la app
class _SubscriptionViewState extends State<SubscriptionView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Registra el observer
    WidgetsBinding.instance.addObserver(this);
    // Carga inicial de datos
    _refreshData();
  }

  @override
  void dispose() {
    // Limpia el observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 3. Este método se llama cuando el estado del ciclo de vida de la app cambia
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Si el usuario regresa a la app (e.g., después de cerrar el navegador de pago)
    if (state == AppLifecycleState.resumed) {
      // Refrescamos los datos para verificar si la suscripción se actualizó
      _refreshData();
    }
  }

  // Función para centralizar la carga de datos
  void _refreshData() {
    // Usamos context.mounted para asegurar que el widget todavía existe
    if (mounted) {
      context.read<ProfileBloc>().add(ProfileGetEvent());
    }
  }

  // 4. Método para lanzar el pago con url_launcher
  Future<void> _launchMercadoPagoCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // launchUrl abrirá una Chrome Custom Tab en Android por defecto
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: No se pudo abrir la página de pago.')),
        );
      }
    }
  }

  // El handler del pago ahora solo dispara el evento del BLoC
  void _handlePayment(int tecnicoId) {
    context
        .read<SubscriptionBloc>()
        .add(CreateSubscriptionPreferenceEvent(tecnicoId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              final userId = state.user?.id;
              if (userId != null) {
                context.read<TecnicoBloc>().add(GetTecnicoByIdEvent(userId));
              }
            }
          },
        ),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            // Quitamos el loading indicator del listener para manejarlo en el builder del botón
            if (state is SubscriptionPreferenceCreated) {
              final String? initPoint = state.preferenceData['init_point'] ??
                  state.preferenceData['sandbox_init_point'];
              if (initPoint != null) {
                // 5. Llamamos a nuestro nuevo método para lanzar la URL
                _launchMercadoPagoCheckout(initPoint);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Error: No se recibió la URL de pago.'),
                      backgroundColor: Colors.red),
                );
              }
            } else if (state is SubscriptionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Suscripción',
              style: TextStyle(fontFamily: 'PatuaOne', fontSize: 28)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<TecnicoBloc, TecnicoState>(
          builder: (context, tecnicoState) {
            if (tecnicoState is TecnicoLoading ||
                tecnicoState is TecnicoInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tecnicoState is TecnicoError) {
              return Center(
                  child:
                      Text('Error al cargar los datos del técnico: '));
            }

            if (tecnicoState is TecnicoLoaded) {
              final tecnico = tecnicoState.tecnico;
              // El backend actualiza suscripcion_activa a través del webhook.
              // Simplemente mostramos la vista correcta basada en ese booleano.
              if (tecnico.suscripcionActiva) {
                return _buildActiveSubscriptionView(tecnico);
              } else {
                return _buildInactiveSubscriptionView(tecnico.usuario.id!);
              }
            }
            return const Center(child: Text('Cargando información...'));
          },
        ),
      ),
    );
  }

  // Los widgets _build... no cambian, por lo que se mantienen igual.
  Widget _buildActiveSubscriptionView(tecnico) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              '¡Tu suscripción está activa!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Fecha de inicio:', tecnico.fechaInicioSuscripcion ?? 'No disponible'),
            _buildInfoRow('Próximo vencimiento:', tecnico.fechaFinSuscripcion ?? 'No disponible'),
            const SizedBox(height: 40),
             ElevatedButton(
                onPressed: () {
                  context.push('/HVtecnico');
                },
                child: const Text('Siguiente'),
              )
          ],
        ),
      ),
    );
  }
  Widget _buildInactiveSubscriptionView(int tecnicoId) {
    final state = context.watch<SubscriptionBloc>().state;
    final bool isLoading = state is SubscriptionLoading;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card_off, color: Colors.orange, size: 80),
          const SizedBox(height: 20),
          const Text(
            'Renueva tu suscripción',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
             textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Accede a todos los beneficios y contacta con más clientes.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          const Text(
            'Monto a Pagar:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'S/ 10.00 PEN', // Precio de tu backend
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: isLoading ? const SizedBox.shrink() : const Icon(Icons.payment, color: Colors.white),
              label: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Pagar Suscripción', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: isLoading ? null : () => _handlePayment(tecnicoId),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
        return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}