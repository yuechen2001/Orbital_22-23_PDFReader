import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile(
      {super.key,
      required this.docString,
      required this.docPath,
      required this.docDate,
      required this.updateRecentCallback});

  // document parameters
  final String docString;
  final String docPath;
  final String docDate;
  // callback for updating the recent files list
  final Function updateRecentCallback;

  @override
  Widget build(BuildContext context) {
    Document doc = Document(docString, docPath, docDate);
    // TODO: ADD FAVOURITES BUTTON TO TOP RIGHT OF LISTTILE
    // TODO: ADD BORDER TO EACH OF THE PDF
    // TODO: ADD PADDING TO EACH OF THE PDF
    return ListTile(
      onTap: () {
        Get.to(ReaderScreen(doc: doc));
        // put the document opened at the top of the recent files list
        updateRecentCallback(doc);
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
