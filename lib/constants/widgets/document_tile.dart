import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.doc});

  final Document doc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(ReaderScreen(doc: doc));
      },
      title: Text(
        doc.doc_title!,
        style: GoogleFonts.nunito(color: Colors.white70),
        overflow: TextOverflow.ellipsis,
      ),
      // todo: add a size attribute
      trailing: Text(
        doc.doc_date!,
        style: GoogleFonts.nunito(color: Colors.grey),
      ),
      leading: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 32.0,
      ),
    );
  }
}
