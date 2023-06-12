import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatefulWidget {
  DocumentTile({super.key, required this.docCon, required this.doc});

  // document parameters
  final DocumentController docCon;
  final Document doc;

  // constants for icon
  static const Icon unfavouritedIcon = Icon(
    Icons.star_border_outlined,
    color: Colors.white70,
  );
  static const Icon favouritedIcon = Icon(
    Icons.star,
    color: Colors.yellow,
  );

  @override
  State<DocumentTile> createState() => _DocumentTileState(docCon, doc);
}

class _DocumentTileState extends State<DocumentTile> {
  // constructor for the document
  _DocumentTileState(
    this.docCon,
    this.doc,
  ) {
    _isFavourited = doc.favourited;
  }

  // fields for the DocumentTileState
  DocumentController docCon;
  Document doc;
  late bool _isFavourited;

  // function to toggle the favourited
  void _toggleFavourite() {
    setState(() {
      // update the state the favourited field of the document
      if (_isFavourited) {
        _isFavourited = false;
      } else {
        _isFavourited = true;
      }
      doc.favourited = _isFavourited;
      docCon.recentFiles.put(doc.docTitle, doc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(vertical: 2),
      onTap: () async {
        Document openedDoc =
            widget.docCon.updateLastOpened(docTitle: widget.doc.docTitle);
        Get.to(ReaderScreen(doc: openedDoc));
        // update the homescreen
      },
      title: Text(
        widget.doc.docTitle,
        style: GoogleFonts.nunito(color: Colors.white70),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: _toggleFavourite,
              child: _isFavourited
                  ? DocumentTile.favouritedIcon
                  : DocumentTile.unfavouritedIcon),
          Text(
            widget.doc.docDate,
            style: GoogleFonts.nunito(color: Colors.grey, fontSize: 16.0),
          ),
        ],
      ),
      leading: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 32.0,
      ),
    );
  }
}