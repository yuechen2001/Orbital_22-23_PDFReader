import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/folders_controller.dart';

import 'package:flutter/material.dart';
import '../../widgets/tiles/document_tile.dart';
import '../../widgets/tiles/folder_document_tile.dart';
import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';

class IndividualFolderScreen extends StatefulWidget {
  const IndividualFolderScreen({Key? key, required this.currentFolder})
      : super(key: key);

  final String currentFolder;

  @override
  State<IndividualFolderScreen> createState() => _IndividualFolderScreenState();
}

class _IndividualFolderScreenState extends State<IndividualFolderScreen> {
  final DocumentController docCon = Get.find<DocumentController>();
  final FoldersController folderCon = Get.put(FoldersController());

  Future<void> _handleAddDocumentToFolder() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color.fromARGB(221, 39, 38, 38),
          elevation: 24.0,
          title: const Text(
            'Documents you can add: ',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: SingleChildScrollView(
                child: ValueListenableBuilder<Box<Document>>(
                  valueListenable: docCon.recentFiles.listenable(),
                  builder: (context, box, _) {
                    final sorted = box.values
                        .where((element) =>
                            !element.folders.contains(widget.currentFolder))
                        .toList()
                      ..sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
                    if (sorted.isEmpty) {
                      return const Center(
                        child: Text("No Documents Found.",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis),
                      );
                    } else {
                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: sorted.length,
                        itemBuilder: (context, index) {
                          Document doc = sorted[index];
                          return FolderDocumentTile(
                            folderName: widget.currentFolder,
                            doc: doc,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(color: Colors.white10);
                        },
                      );
                    }
                  },
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black87.withOpacity(1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                const Text("You are currently in: ",
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70)),
                Text(widget.currentFolder,
                    style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70))
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
              child: Text("Your Files",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70)),
            ),
            const Divider(color: Colors.white),
            ValueListenableBuilder<Box<Document>>(
              valueListenable: docCon.recentFiles.listenable(),
              builder: (context, box, _) {
                final sorted = box.values
                    .where((element) =>
                        element.folders.contains(widget.currentFolder))
                    .toList()
                  ..sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
                if (sorted.isEmpty) {
                  return const Center(
                    child: Text("No Documents Found.",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis),
                  );
                } else {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      Document doc = sorted[index];
                      return DocumentTile(
                        folderName: widget.currentFolder,
                        doc: doc,
                        canDelete: true,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.white10);
                    },
                  );
                }
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.exit_to_app_sharp,
                      color: Colors.white70,
                    ),
                    label: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _handleAddDocumentToFolder,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
