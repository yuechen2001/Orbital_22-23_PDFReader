import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';

class FolderDocumentTile extends StatelessWidget {
  FolderDocumentTile({super.key, required this.doc, required this.folderName});

  final Document doc;
  final String folderName;
  final DocumentController docCon = Get.find<DocumentController>();

  @override
  Widget build(BuildContext context) {
    Future<void> handleMissingFile() async {
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
                ],
              ));
    }

    return ListTile(
      visualDensity: const VisualDensity(vertical: 2),
      onTap: () async {
        // gc: file does not exist
        if (!File(doc.docPath).existsSync()) {
          // show warning
          handleMissingFile();
        } else {
          docCon.addToFolder(folderName, doc.docTitle);
        }
      },
      title: Text(
        doc.docTitle,
        style: const TextStyle(
          color: Colors.white70,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      leading: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 32.0,
      ),
    );
  }
}
