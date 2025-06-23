import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MercadoPagoWebView extends StatefulWidget {
  final String url;
  const MercadoPagoWebView({super.key, required this.url});

  @override
  State<MercadoPagoWebView> createState() => _MercadoPagoWebViewState();
}

class _MercadoPagoWebViewState extends State<MercadoPagoWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Escucha las URLs de redirección de Mercado Pago
            if (request.url.contains('/success')) {
              _showFeedbackAndPop('¡Pago exitoso!', Colors.green);
              return NavigationDecision.prevent; 
            }
            if (request.url.contains('/failure')) {
              _showFeedbackAndPop('El pago falló. Por favor, inténtalo de nuevo.', Colors.red);
              return NavigationDecision.prevent;
            }
            if (request.url.contains('/pending')) {
               _showFeedbackAndPop('Tu pago está pendiente de aprobación.', Colors.orange);
              return NavigationDecision.prevent;
            }
            // Permite la navegación para cualquier otra URL
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  
  void _showFeedbackAndPop(String message, Color color) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
      // Cierra el WebView después de un breve momento
      Future.delayed(const Duration(seconds: 1), () {
        if(mounted) {
           Navigator.of(context).pop();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Pago'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
