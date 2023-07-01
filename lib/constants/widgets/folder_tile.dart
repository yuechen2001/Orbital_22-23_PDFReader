import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/folders_controller.dart';
import 'dart:io';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/reader_screen.dart';

class FolderTile extends StatefulWidget {
  const FolderTile({super.key, required this.folderName});

  final String folderName;

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  DocumentController docCon = Get.find<DocumentController>();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 2),
      onTap: () async {
        print("It works!");
      },
      title: Text(
        widget.folderName,
        style: const TextStyle(
          color: Colors.white70,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _DeleteButton(folderName: widget.folderName),
      leading: const Icon(
        Icons.folder_copy_rounded,
        color: Colors.red,
        size: 32.0,
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  _DeleteButton({required this.folderName});

  final String folderName;
  final FoldersController folderCon = Get.find<FoldersController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color.fromARGB(221, 39, 38, 38),
                  elevation: 24.0,
                  title: const Text(
                    'Are you sure about deleting this folder?',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  content: const Text(
                    'Deleted folders cannot be recovered.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        folderCon.deleteFolder(folderName);
                      },
                      child: const Text(
                        'Confirm Delete',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    )
                  ],
                ));
      },
      child: const Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
    );
  }
}
