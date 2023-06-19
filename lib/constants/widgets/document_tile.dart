import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

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
  // function to toggle the favourite status of the document
  void _toggleFavourite() {
    if (widget.doc.favourited) {
      widget.doc.favourited = false;
    } else {
      widget.doc.favourited = true;
    }
    widget.docCon.recentFiles.put(widget.doc.docTitle, widget.doc);
  }

  // constants for favourite icon of the document tile
  static const Icon unfavouritedIcon = Icon(
    Icons.star_border_outlined,
    color: Colors.white70,
  );
  static const Icon favouritedIcon = Icon(
    Icons.star,
    color: Colors.yellow,
  );
  // access the document controller
  DocumentController docCon = Get.find();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 2),
      onTap: () async {
        // gc: file does not exist
        if (!File(widget.doc.docPath).existsSync()) {
          // show warning
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              // refresh the recent files screen
              docCon.refreshDocuments();
              return AlertDialog(
                backgroundColor: Colors.black87,
                elevation: 24.0,
                title: const Text(
                  'File Not Available',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                content: const Text(
                  'The file you are trying to open is no longer available and cannot be opened.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  )
                ],
              );
            },
          );
          return;
        }
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
            // tag the state of the favourites icon to the favourited state of
            // the document
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
