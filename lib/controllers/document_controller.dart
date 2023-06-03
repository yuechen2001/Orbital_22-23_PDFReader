import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/document_model.dart';

class DocumentController extends GetxController {
  List<Document> docList = [];
  // static Map<Document, int> docSet = HashMap();

  // method that opens the local file system for users to pick files
  // this will be called once the file button is clicked/tapped
  Future<PlatformFile?> pickFile() async {
    // open the storage for user to choose 1 pdf file
    // pickFiles parameter filters only for pdf files
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // gc: no file is picked => terminate early
    if (result == null) return null;
    // get the file
    PlatformFile file = result.files.first;
    // return the platform file
    return file;
  }

  Future<Document?> createNewDocument() async {
    // pick new file
    PlatformFile? picked = await pickFile();
    if (picked != null) {
      // get the date and time
      DateTime now = DateTime.now();
      // format the date
      String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);
      // convert the file to a document object
      Document doc = Document(picked.name, picked.path, formattedDate);
      // update the master doclist
      updateDocument(doc);
      return doc;
    } else {
      // todo: think about what to do if user picks nothing
      return null;
    }
  }

  // todo: find faster way to do this
  // method that updates the doclist
  void updateDocument(Document document) {
    // case where inside the doclist already => remove the old entry
    if (docList.contains(document)) {
      docList.remove(document);
    }
    docList.insert(0, document);
    // Refresh the UI to show new document
    update();
  }
}
