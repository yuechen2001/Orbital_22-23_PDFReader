import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoldersController extends GetxController {
  bool isLoading = false;
  late final Box<String> existingFolders;

  @override
  void onInit() {
    super.onInit();
    existingFolders = Hive.box<String>("existing_folders");
  }

  String? createNewFolder(String newName) {
    // check if folder exists in the system
    // if not, add it to the box and return the folder name
    if (existingFolders.get(newName) == null) {
      existingFolders.put(newName, newName);
      update();
      return newName;
    } else {
      update();
      return null;
    }
  }

  void deleteFolder(String folderName) {
    existingFolders.delete(folderName);
    update();
  }

  void clearFolders() {
    existingFolders.clear();
    update();
  }

  @override
  void dispose() {
    Get.delete<FoldersController>();
    super.dispose();
  }
}
