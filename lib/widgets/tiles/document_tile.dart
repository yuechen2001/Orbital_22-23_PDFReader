import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:pdfreader2/controllers/favourite_controller.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader/reader_screen.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({
    super.key,
    this.folderName,
    required this.doc,
    required this.canDelete,
  });

  final String? folderName;
  final Document doc;
  final bool canDelete;

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

  Future<void> _handleDeletionFromFolder() async {
    if (widget.canDelete) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color.fromARGB(221, 39, 38, 38),
          elevation: 24.0,
          title: const Text(
            'Remove file from folder?',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          content: const Text(
            'You can always add the file back again if you want to!',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                docCon.removeFromFolder(
                    widget.folderName!, widget.doc.docTitle);
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
    }
  }

  Future<void> _handleMissingFile() async {
    // show warning
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
                backgroundColor: const Color.fromARGB(221, 39, 38, 38),
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
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 2),
      onLongPress: _handleDeletionFromFolder,
      onTap: () {
        // gc: file does not exist
        if (!File(widget.doc.docPath).existsSync()) {
          _handleMissingFile();
        } else {
          // case where the document exists in the user's local filesystem
          Document openedDoc =
              docCon.updateLastOpened(widget.doc.docTitle);
          // create a new readerscreen to open the document for viewing
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
