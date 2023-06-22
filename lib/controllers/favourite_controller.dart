import 'package:get/get.dart';
import 'package:pdfreader2/controllers/document_controller.dart';

import '../models/document_model.dart';

class FavouriteController extends GetxController {
  late Document doc;

  FavouriteController({required this.doc}) {
    doc = doc;
  }

  void toggleFavourite() {
    DocumentController docCon = Get.find<DocumentController>();
    doc.favourited = !doc.favourited;
    docCon.recentFiles.put(doc.docTitle, doc);
    update();
  }

  @override
  void dispose() {
    Get.delete<FavouriteController>();
    super.dispose();
  }
}
