import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/constants/widgets/pdf_page_view_with_annotations.dart';

class ReaderController extends GetxController {
  RxString backgroundColour = "White".obs;
  RxBool textBoxMode = false.obs;
  List<PdfPageViewWithAnnotations> children = [];
  List<RxList> annotationsList = [];
  FocusNode focusNode = FocusNode();

  void addChildren(List<Widget> c) {
    // print(c.length);
    if (children.length != 0) {
      return;
    }
    for (Widget child in c) {
      children.add(child as PdfPageViewWithAnnotations);
      annotationsList.add([].obs);
    }
  }

  void updateSelectedTextbox(FocusNode f) {
    focusNode = f;
  }

  void clearPages() {
    children = [];
  }

  void updateBackgroundcolour(String selectedValue) {
    backgroundColour.value = selectedValue;
  }

  @override
  void dispose() {
    Get.delete<ReaderController>();
    super.dispose();
  }
}
