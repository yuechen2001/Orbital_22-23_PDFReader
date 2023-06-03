import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfreader2/contorllers/reader_countroller.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  ReaderScreen({Key? key, required this.doc}) : super(key: key);
  Document doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReaderController readCon = Get.put(ReaderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // // todo: remove the appbar
        // appBar: AppBar(
        //   backgroundColor: Colors.black87,
        //   title: Text(widget.doc.doc_title!),
        // ),
        // todo: add the parent row
        body: Row(
      children: [
        // component 1: the side menu
        const _SideBar(),
        _TopMenuBar(doc: widget.doc)
        // component 2: the edit menu + the PDF view screen combined
      ],
    ));
  }
}

class _SideBar extends StatefulWidget {
  const _SideBar({Key? key}) : super(key: key);
  @override
  State<_SideBar> createState() => SideBar();
}

class SideBar extends State<_SideBar> {
  @override
  Widget build(BuildContext context) {
    return // todo: make this a sized box with infinite height
        SizedBox(
            width: 200.0,
            height: double.infinity,
            child: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  const SizedBox(
                    width: 200.0,
                    height: 30.0,
                    child: SizedBox.shrink(),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save_outlined,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.zoom_in,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Zoom in",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.zoom_out,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Zoom out",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.desktop_mac_sharp,
                            color: Colors.white70),
                        label: const Text("Save As",
                            style: TextStyle(color: Colors.white70))),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.exit_to_app_sharp,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Back",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                ],
              ),
            ));
  }
}

class _TopMenuBar extends StatefulWidget {
  const _TopMenuBar({Key? key, required this.doc}) : super(key: key);

  final Document doc;

  @override
  State<_TopMenuBar> createState() => TopMenuBar();
}

class TopMenuBar extends State<_TopMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        // todo: add the children
        // add the top menu bar
        SizedBox(
            height: 50.0,
            width: double.infinity,
            child: Container(
              color: Colors.black87,
              child: Row(
                // todo: add menu options
                children: [
                  // textbox
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Textbox",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  // background colour
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.contrast,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Background Colour",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  // text size
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.format_size,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Text Size",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  // text font
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.title,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Text Font",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  // draw
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.draw,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Draw",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                  // favourite
                  Expanded(
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_outlined,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Favourite",
                          style: TextStyle(color: Colors.white70),
                        )),
                  ),
                ],
              ),
            )),
        // add the pdf viewer screen
        Expanded(child: SfPdfViewer.file(File(widget.doc.doc_path!)))
      ],
    ));
  }
}
