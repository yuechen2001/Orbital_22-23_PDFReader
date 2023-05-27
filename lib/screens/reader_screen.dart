import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  ReaderScreen(this.doc, {Key? key}) : super(key: key);
  Document doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(widget.doc.doc_title!),
        ),
        body: SfPdfViewer.file(File(widget.doc.doc_path!)));
  }
}
