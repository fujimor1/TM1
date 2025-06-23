// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/presentation/widgets/CustomTextField.dart';

// class SubscriptionView extends StatelessWidget {
//   const SubscriptionView({super.key});
//   static String name = '/Pcard';

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
//     final OutlineInputBorder border = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey.shade300),
//     );

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF267BFF), Color(0xFF586BFF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Icon(Icons.arrow_back, color: Colors.white),
//                   const Text('Pagar', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ],
//               ),
//             ),

//             // Métodos de pago
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF267BFF), Color(0xFF586BFF)],
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: const [
//                     PaymentMethodIcon(asset: Icons.credit_card, label: 'VISA'),
//                     PaymentMethodIcon(asset: Icons.credit_card, label: 'MasterCard'),
//                     PaymentMethodIcon(asset: Icons.credit_card, label: 'AmEx'),
//                     PaymentMethodIcon(asset: Icons.account_balance_wallet, label: 'PayPal'),
//                   ],
//                 ),
//               ),
//             ),

//             // Formulario de pago
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Tus datos de pago', style: titleStyle),
//                     const SizedBox(height: 12),
//                     const CustomTextField(
//                       label: 'Titular de la tarjeta',
//                       hintText: 'Ej. Rodolfo Rivera',
//                     ),
//                     const CustomTextField(
//                       label: 'Número de la tarjeta',
//                       hintText: 'XXXX XXXX XXXX XXXX',
//                       keyboardType: TextInputType.number,
//                     ),
//                     Row(
//                       children: const [
//                         Expanded(
//                           child: CustomTextField(
//                             label: 'Fecha de vencimiento',
//                             hintText: 'MM/YYYY',
//                             keyboardType: TextInputType.datetime,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: CustomTextField(
//                             label: 'CVV',
//                             hintText: 'Ej. 123',
//                             keyboardType: TextInputType.number,
//                             suffixIcon: Icon(Icons.info_outline, size: 18),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     const Divider(),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Monto total',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       'S/ 30.00 PEN',
//                       style: TextStyle(fontSize: 24, color: Colors.teal, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF54BAB9),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         icon: const Icon(Icons.lock, color: Colors.white),
//                         label: const Text(
//                           'Pagar ahora',
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                         onPressed: () {
//                           context.push('/HVtecnico');
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PaymentMethodIcon extends StatelessWidget {
//   final IconData asset;
//   final String label;

//   const PaymentMethodIcon({super.key, required this.asset, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(asset, size: 32, color: Colors.blue),
//           const SizedBox(height: 4),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
// import 'package:tm1/presentation/bloc/suscripcion/bloc/subscription_bloc.dart';
// import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';
// import 'package:tm1/presentation/views/Paymment/mercado_pago_webview.dart';

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
//     // Inicia la carga de datos del perfil del usuario
//     context.read<ProfileBloc>().add(ProfileGetEvent());
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
//               // Una vez cargado el perfil, obtenemos los datos del técnico
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
//               // Si la preferencia de pago se crea, obtenemos la URL y abrimos el WebView
//               final String? initPoint = state.preferenceData['init_point'];
//               if (initPoint != null) {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => MercadoPagoWebView(url: initPoint),
//                 ));
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
//               // ---- UI DINÁMICA BASADA EN EL ESTADO DE LA SUSCRIPCIÓN ----
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

//   // Widget para cuando la suscripción está ACTIVA
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

//   // Widget para cuando la suscripción está INACTIVA
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
