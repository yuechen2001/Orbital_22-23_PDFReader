import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../models/document_model.dart';

class DocumentController extends GetxController {
  bool isLoading = false;
  late final Box<Document> recentFiles;

  @override
  void onInit() {
    super.onInit();
    recentFiles = Hive.box<Document>("recent_files");
  }

  Future<Document?> createNewDocument() async {
    // pick new file
    PlatformFile? picked = await pickFile();
    if (picked != null) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);
      String docTitle = picked.name;
      String formattedTitle = docTitle.substring(0, docTitle.lastIndexOf('.'));
      // get the annotations list if doc exists, else set as null
      List<List<dynamic>> l;
      // get the last page opened if doc exists, else set as 0
      int page;
      if (recentFiles.containsKey(picked.name)) {
        l = recentFiles.get(picked.name)!.annotations;
        page = recentFiles.get(picked.name)!.lastPageOpened;
      } else {
        l = [];
        page = 0;
      }
      // convert the file to a document object
      Document doc = Document(
        docTitle: formattedTitle,
        docPath: picked.path!,
        docDate: formattedDate,
        lastOpened: now,
        favourited: false,
        annotations: l,
        folders: [],
        lastPageOpened: page,
      );
      recentFiles.put(formattedTitle, doc);
      return doc;
    } else {
      return null;
    }
  }

  Future<PlatformFile?> pickFile() async {
    // open the storage for user to choose 1 pdf file
    // pickFiles parameter filters only for pdf files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      lockParentWindow: true,
    );
    // gc: no file is picked => terminate early
    if (result == null) return null;
    // get the file
    PlatformFile file = result.files.first;
    return file;
  }

  Document updateLastOpened(String docTitle) {
    Document curr = recentFiles.get(docTitle)!;

    // update the last opened time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);

    // convert the file to a document object
    Document doc = Document(
      docTitle: docTitle,
      docPath: curr.docPath,
      docDate: formattedDate,
      lastOpened: now,
      favourited: curr.favourited,
      annotations: curr.annotations,
      folders: curr.folders,
      lastPageOpened: curr.lastPageOpened,
    );
    recentFiles.put(docTitle, doc);

    return doc;
  }

  void addToFolder(String folderName, String docTitle) {
    Document curr = recentFiles.get(docTitle)!;

    // update the folder list
    curr.folders.add(folderName);
    recentFiles.put(docTitle, curr);
  }

  void removeFromFolder(String folderName, String docTitle) {
    Document curr = recentFiles.get(docTitle)!;

    // update the folder list
    curr.folders.remove(folderName);
    recentFiles.put(docTitle, curr);
  }

  // method that will loop over all the files in the db, deleting any files
  // that no longer exist
  void removeMissingDocuments() {
    // convert the recentFiles to an iterable
    Iterable<MapEntry<dynamic, Document>> filesIter =
        recentFiles.toMap().entries;
    // loop over the iterable
    for (MapEntry<dynamic, Document> file in filesIter) {
      // if the file no longer exists in the system, update the recentFiles box
      if (!File(file.value.docPath).existsSync()) {
        recentFiles.delete(file.key);
      }
    }
  }

  void clearRecentFiles() {
    recentFiles.clear();
    update();
  }

  @override
  void dispose() {
    Get.delete<DocumentController>();
    super.dispose();
  }
}
