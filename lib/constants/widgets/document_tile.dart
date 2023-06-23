import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:pdfreader2/controllers/favourite_controller.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({super.key, required this.doc});

  final Document doc;

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  DocumentController docCon = Get.find<DocumentController>();
  // constants for favourite icon of the document tile
  static Icon unfavouritedIcon = const Icon(
    Icons.star,
    color: Colors.yellow,
  );

  static Icon favouritedIcon = const Icon(
    Icons.star_border_outlined,
    color: Colors.white70,
  );

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
            builder: (BuildContext context) => AlertDialog(
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
                    docCon.removeMissingDocuments();
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
            ),
          );
        } else {
          // case where the document exists in the user's local filesystem
          Document openedDoc =
              docCon.updateLastOpened(docTitle: widget.doc.docTitle);
          Get.to(ReaderScreen(doc: openedDoc));
        }
      },
      title: Text(
        widget.doc.docTitle,
        style: const TextStyle(
          color: Colors.white70,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              FavouriteController favCon = Get.put(
                FavouriteController(doc: widget.doc),
              );
              favCon.toggleFavourite();
              favCon.dispose();
            },
            child: ValueListenableBuilder<Box<Document>>(
              valueListenable: docCon.recentFiles.listenable(),
              builder: (context, box, _) {
                return box.get(widget.doc.docTitle)!.favourited
                    ? unfavouritedIcon
                    : favouritedIcon;
              },
            ),
          ),
          Text(
            widget.doc.docDate,
            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
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
