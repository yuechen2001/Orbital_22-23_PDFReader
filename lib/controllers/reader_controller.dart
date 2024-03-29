import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/view/reader/pdf_with_annotations.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:pdfreader2/pdfviewer/pdf_viewer_library.dart';

class ReaderController extends GetxController {
  RxString backgroundColour = "Dark".obs;
  RxBool textBoxMode = false.obs;
  List<PdfPageViewWithAnnotations> children = [];
  List<RxList> annotationsList = [];
  RxDouble maxX = (0.0).obs;
  RxDouble maxY = (0.0).obs;
  RxDouble currentFontSize = (12.0).obs;
  Rx<Color> currentColor = (Colors.white70).obs;
  late Document doc;
  Rx<PdfViewerController> pdfController = PdfViewerController().obs;

  void updateMaxLocalBounds(double x, double y) {
    maxX.value = x;
    maxY.value = y;
  }

  void addChildren(List<Widget> c) {
    if (children.isNotEmpty) {
      return;
    }
    for (Widget child in c) {
      children.add(child as PdfPageViewWithAnnotations);
    }
    if (annotationsList.isEmpty) {
      for (int i = 0; i < children.length; i++) {
        annotationsList.add([].obs);
      }
    }
  }

  void clearPages() {
    children = [];
    annotationsList = [];
  }

  void updateBackgroundcolour(String selectedValue) {
    backgroundColour.value = selectedValue;
    updateTextboxColour();
  }

  void updateTextboxColour() {
    // case where white
    if (backgroundColour.value == "White") {
      currentColor.value = Colors.black;
    } else if (backgroundColour.value == "Dark") {
      // case where dark
      currentColor.value = Colors.white70;
    } else {
      // case where sepia
      currentColor.value = Colors.black;
    }
  }

  void refreshAllAnnotations() {
    for (RxList l in annotationsList) {
      l.refresh();
    }
  }

  void setDoc(Document doc) {
    this.doc = doc;
    setAnnotations();
  }

  void setAnnotations() {
    annotationsList = [];
    for (int i = 0; i < doc.annotations.length; i++) {
      RxList<dynamic> t = [...doc.annotations[i]].obs;
      annotationsList.add(t);
    }
  }

  void saveAnnotations() {
    doc.annotations = [];
    for (int i = 0; i < annotationsList.length; i++) {
      doc.annotations.add([...annotationsList[i]]);
    }
    clearPages();
  }

  void savePageNumber(int page) {
    doc.lastPageOpened = page;
  }

  @override
  void dispose() {
    Get.delete<ReaderController>();
    super.dispose();
  }
}
