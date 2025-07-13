// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PdfViewerScreen extends StatelessWidget {
//   final String localPath;

//   const PdfViewerScreen({super.key, required this.localPath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Términos y Condiciones",
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: PDFView(
//         filePath: localPath,
//       ),
//     );
//   }
// }


// pdf_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfViewerScreen extends StatefulWidget {
  final String localPath;

  const PdfViewerScreen({super.key, required this.localPath});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _pages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Términos y Condiciones",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.localPath,
            enableSwipe: true, // Permitir deslizar para cambiar de página
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            // --- Callbacks para diagnóstico ---
            onRender: (pages) {
              setState(() {
                _pages = pages!;
                _isReady = true;
              });
              print("PDF renderizado: $_pages páginas.");
            },
            onError: (error) {
              setState(() {
                _errorMessage = error.toString();
              });
              print("Error al cargar PDF: $error");
            },
            onPageError: (page, error) {
              setState(() {
                _errorMessage = 'Error en la página $page: ${error.toString()}';
              });
              print('Error en la página $page: $error');
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page!;
              });
              print('Página cambiada a: $page/$total');
            },
          ),
          // Si hay un mensaje de error, muéstralo en la pantalla
          if (_errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No se pudo mostrar el PDF.\nError: $_errorMessage",
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Mientras no esté listo y no haya error, muestra un indicador
          if (!_isReady && _errorMessage.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}