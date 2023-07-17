import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/constants/widgets/pdf_page_view_with_annotations.dart';

class ReaderController extends GetxController {
  RxString backgroundColour = "White".obs;
  RxBool textBoxMode = false.obs;
  List<PdfPageViewWithAnnotations> children = [];
  List<RxList> annotationsList = [];
  RxDouble maxX = (0.0).obs;
  RxDouble maxY = (0.0).obs;
  RxDouble currentFontSize = (12.0).obs;
  Rx<Color> currentColor = (Colors.black).obs;

  void updateMaxLocalBounds(double x, double y) {
    maxX.value = x;
    maxY.value = y;
  }

  void addChildren(List<Widget> c) {
    if (children.length != 0) {
      return;
    }
    for (Widget child in c) {
      children.add(child as PdfPageViewWithAnnotations);
      annotationsList.add([].obs);
    }
  }

  void clearPages() {
    children = [];
    annotationsList = [];
    maxX = (0.0).obs;
    maxY = (0.0).obs;
  }

  void updateBackgroundcolour(String selectedValue) {
    backgroundColour.value = selectedValue;
    updateTextboxColour();
    // refreshAllAnnotations();
    print('refreshed');
    // update();
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

  @override
  void dispose() {
    Get.delete<ReaderController>();
    super.dispose();
  }
}
