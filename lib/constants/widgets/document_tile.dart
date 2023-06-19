import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/favourite_controller.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({super.key, required this.docCon, required this.doc});

  // document parameters
  final DocumentController docCon;
  final Document doc;

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  // constants for favourite icon of the document tile
  static Icon unfavouritedIcon = const Icon(Icons.star, color: Colors.yellow);

  static Icon favouritedIcon =
      const Icon(Icons.star_border_outlined, color: Colors.white70);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 2),
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
            onTap: () {
              FavouriteController favCon =
                  Get.put(FavouriteController(doc: widget.doc));
              favCon.toggleFavourite();
              favCon.dispose();
            },
            child: ValueListenableBuilder<Box<Document>>(
              valueListenable: widget.docCon.recentFiles.listenable(),
              builder: (context, box, _) {
                return box.get(widget.doc.docTitle)!.favourited
                    ? favouritedIcon
                    : unfavouritedIcon;
              },
            ),
          ),
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
