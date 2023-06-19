import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/document_controller.dart';

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
      body: Row(
        children: [
          // component 1: the side menu
          const _SideBar(),
          _TopMenuBar(doc: widget.doc)
          // component 2: the edit menu + the PDF view screen combined
        ],
      ),
    );
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
    // retrieve document controller. this is to refresh the recent files db
    DocumentController docCon = Get.find();
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
                ),
              ),
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
                ),
              ),
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
                ),
              ),
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
                  // refresh the home screen
                  docCon.refreshDocuments();
                  Get.back();
                },
                icon: const Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white70,
                ),
                label: const Text(
                  "Back",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopMenuBar extends StatefulWidget {
  const _TopMenuBar({Key? key, required this.doc}) : super(key: key);

  final Document doc;

  @override
  State<_TopMenuBar> createState() => TopMenuBar();
}

class TopMenuBar extends State<_TopMenuBar> {
  // retrieve the document controller using Get
  DocumentController docCon = Get.find();

  @override
  Widget build(BuildContext context) {
    // initialize a favourite controller
    final FavouriteIconController favouriteIconController = Get.put(
      FavouriteIconController(
        doc: docCon.recentFiles.get(widget.doc.docTitle),
      ),
    );

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
                      ),
                    ),
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
                      ),
                    ),
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
                      ),
                    ),
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
                      ),
                    ),
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
                      ),
                    ),
                  ),
                  // favourite
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        favouriteIconController.toggleFavourite();
                      },
                      icon: Obx(() =>
                          favouriteIconController.currentIconStatus.value),
                      label: const Text(
                        "Favourite",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // add the pdf viewer screen
          Expanded(child: SfPdfViewer.file(File(widget.doc.docPath)))
        ],
      ),
    );
  }
}

class FavouriteIconController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  var favourited;
  static const Icon favouritedIcon = Icon(
    Icons.favorite_outlined,
    color: Colors.red,
  );
  static const Icon unfavouritedIcon = Icon(
    Icons.favorite_outlined,
    color: Colors.white70,
  );
  var currentIconStatus = favouritedIcon.obs;
  late Document? doc;

  FavouriteIconController({required this.doc}) {
    doc = doc;
    currentIconStatus.value =
        doc!.favourited ? favouritedIcon : unfavouritedIcon;
  }

  void toggleFavourite() {
    // get document controller
    DocumentController docCon = Get.find();
    // case where document is favourited
    if (currentIconStatus.value == favouritedIcon) {
      // update db
      doc!.favourited = false;
      // change current icon
      currentIconStatus.value = unfavouritedIcon;
    } else {
      // update db
      doc!.favourited = true;
      // change current icon
      currentIconStatus.value = favouritedIcon;
    }
    docCon.recentFiles.put(doc!.docTitle, doc!);
  }
}
