import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewerPDF extends StatefulWidget {
  final String path;
  const ViewerPDF({super.key, required this.path});

  @override
  State<ViewerPDF> createState() => _ViewerPDFState();
}

class _ViewerPDFState extends State<ViewerPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('viewer'),
      ),
      body: PDFView(
        filePath: widget.path,
      ),
    );
  }
}
