import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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

      // convert the file to a document object
      Document doc =
          Document(picked.name, picked.path!, formattedDate, now, false);
      recentFiles.put(picked.name, doc);

      return doc;
    } else {
      return null;
    }
  }

  Future<PlatformFile?> pickFile() async {
    // open the storage for user to choose 1 pdf file
    // NOTE: pickFiles parameter filters only for pdf files
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // no file is picked => terminate early
    if (result == null) return null;
    // else, get the file
    PlatformFile file = result.files.first;
    return file;
  }

  Document updateLastOpened({required String docTitle}) {
    Document curr = recentFiles.get(docTitle)!;

    // update the last opened time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);

    // convert the file to a document object
    Document doc = Document(
        curr.docTitle, curr.docPath, formattedDate, now, curr.favourited);
    recentFiles.put(doc.docTitle, doc);

    return doc;
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
