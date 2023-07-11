import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/document_model.dart';

class FoldersController extends GetxController {
  bool isLoading = false;
  late final Box<String> existingFolders;
  late final Box<Document> recentFiles;

  @override
  void onInit() {
    super.onInit();
    existingFolders = Hive.box<String>("existing_folders");
    recentFiles = Hive.box<Document>("recent_files");
  }

  String? createNewFolder(String newName) {
    // check if folder exists in the system
    // if not, add it to the box and return the folder name
    if (existingFolders.get(newName) == null) {
      existingFolders.put(newName, newName);
      update();
      return newName;
    } else {
      return null;
    }
  }

  void deleteFolder(String folderName) {
    existingFolders.delete(folderName);

    // Delete the folder reference from all the documents
    Iterable<MapEntry<dynamic, Document>> filesIter =
        recentFiles.toMap().entries;
    for (MapEntry<dynamic, Document> file in filesIter) {
      file.value.folders.remove(folderName);
    }
    update();
  }

  void clearFolders() {
    existingFolders.clear();

    // Delete all folders references from all the documents
    Iterable<MapEntry<dynamic, Document>> filesIter =
        recentFiles.toMap().entries;
    for (MapEntry<dynamic, Document> file in filesIter) {
      file.value.folders.clear();
    }
    update();
  }

  @override
  void dispose() {
    Get.delete<FoldersController>();
    super.dispose();
  }
}
