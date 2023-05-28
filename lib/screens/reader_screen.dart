import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  ReaderScreen(this.doc, {Key? key}) : super(key: key);
  Document doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
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
        // todo: make this a sized box with infinite height
        SizedBox(
            width: 100.0,
            height: double.infinity,
            child: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  const SizedBox(
                    width: 100.0,
                    height: 30.0,
                    child: SizedBox.shrink(),
                  ),
                  SizedBox(
                    width: 100.0,
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
                    width: 100.0,
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
                    width: 100.0,
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
                    width: 100.0,
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
                    width: 100.0,
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
            )),
        // component 2: the edit menu + the PDF view screen combined
        Expanded(
            child: Column(
          children: [
            // todo: add the children
            // add the top menu bar
            SizedBox(
                height: 50.0,
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
                              Icons.exit_to_app_sharp,
                              color: Colors.white70,
                            ),
                            label: const Text(
                              "Textbox",
                              style: TextStyle(color: Colors.white70),
                            )),
                      ),
                      // background colour
                      Expanded(
                        child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.exit_to_app_sharp,
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
                              Icons.exit_to_app_sharp,
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
                              Icons.exit_to_app_sharp,
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
                              Icons.exit_to_app_sharp,
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
                              Icons.exit_to_app_sharp,
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
        )),
      ],
    ));
  }
}
