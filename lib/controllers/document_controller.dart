import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/document_model.dart';

class DocumentController extends GetxController {
  // open DB for recent files
  final db = sqlite3.open('data/recent_files.db');
  // result set from the database
  late ResultSet resultSet;

  // constructs an empty table
  DocumentController() {
    resultSet = ResultSet([], [], []);
  }

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
      // update recent_files.db
      updateDocument(doc);
      return doc;
    } else {
      // todo: think about what to do if user picks nothing
      return null;
    }
  }

  // method that updates the doclist
  void updateDocument(Document? document) {
    if (document != null) {
      // remove any old entry that has the exact same filepath as the current file
      db.execute("""
      DELETE FROM recent_files WHERE filepath='${document.doc_path}';
      """);
      // add the entry into the db
      db.execute("""
      INSERT INTO recent_files (filename, filepath, filedate, favourited)
      VALUES('${document.doc_title}', '${document.doc_path}', '${document.doc_date}', false);
      """);
    }
    // update the recent files screen after update
    resultSet = db.select('''
    SELECT * FROM recent_files
    ORDER BY documentid DESC
    ''');
    // call update to refresh the main screen
    update();
  }

  // method that clears the recent files db
  void clearDB() {
    db.execute('''
    DELETE FROM recent_files
    ''');
  }
}
