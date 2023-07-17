import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';

// ignore: must_be_immutable
class PdfPageViewWithAnnotations extends StatefulWidget {
  PdfPageViewWithAnnotations(
      {super.key, required this.page, required this.pageIndex});
  // widget for the page
  Widget page;
  // page index
  int pageIndex;
  // pull out the readercontroller
  ReaderController readCon = Get.find<ReaderController>();
  // renderbox
  late RenderBox rb;

  // function to update the annotations list
  void updateAnnotations(Widget w) {
    readCon.annotationsList[pageIndex].add(w);
  }

  @override
  State<PdfPageViewWithAnnotations> createState() =>
      PdfPageViewWithAnnotationsState();
}

class PdfPageViewWithAnnotationsState
    extends State<PdfPageViewWithAnnotations> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initMaxOffset();
    });
  }

  void initMaxOffset() {
    widget.rb = context.findRenderObject() as RenderBox;
    widget.readCon
        .updateMaxLocalBounds(widget.rb.size.width, widget.rb.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.page,
        ...widget.readCon.annotationsList[widget.pageIndex],
      ],
    );
  }
}
