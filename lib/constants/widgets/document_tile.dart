import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile(
      {super.key,
      required this.docCon,
      required this.docString,
      required this.docPath,
      required this.docDate});

  // document parameters
  final DocumentController docCon;
  final String docString;
  final String docPath;
  final String docDate;

  @override
  Widget build(BuildContext context) {
    // TODO: ADD FAVOURITES BUTTON TO TOP RIGHT OF LISTTILE
    // TODO: ADD BORDER TO EACH OF THE PDF
    // TODO: ADD PADDING TO EACH OF THE PDF
    return ListTile(
      onTap: () async {
        Document openedDoc = docCon.updateLastOpened(docTitle: docString);
        Get.to(ReaderScreen(doc: openedDoc));
      },
      title: Text(
        docString,
        style: GoogleFonts.nunito(color: Colors.white70),
        overflow: TextOverflow.ellipsis,
      ),
      // todo: add a size attribute
      trailing: Text(
        docDate,
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
