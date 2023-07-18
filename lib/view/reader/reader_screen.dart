import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:pdfreader2/pdfviewer/pdf_viewer_library.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/document_controller.dart';
import 'package:pdfreader2/controllers/favourite_controller.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key, required this.doc}) : super(key: key);
  final Document doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReaderController readCon = Get.put<ReaderController>(ReaderController());
  // pdf controller for various features
  PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    readCon.setDoc(widget.doc);
    _pdfViewerController = readCon.pdfController.value;
    _pdfViewerController.jumpToPage(widget.doc.lastPageOpened);
  }

  @override
  void dispose() {
    // dispose the reader controller
    readCon.dispose();
    super.dispose();
  }

  // method to compute the initial zoom level
  double computeZoomLevel(BuildContext context) {
    double res = readCon.maxX.value == 0
        ? MediaQuery.of(context).size.width / 670
        : MediaQuery.of(context).size.width / readCon.maxX.value;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // component 2: the edit menu
                _TopMenuBar(
                  doc: widget.doc,
                  pdfViewerController: _pdfViewerController,
                ),
                // component 3: the PDF view screen
                Expanded(
                  child: Stack(
                    children: [
                      SfPdfViewer.file(
                        File(widget.doc.docPath),
                        maxZoomLevel: double.infinity,
                        controller: _pdfViewerController,
                        initialZoomLevel: computeZoomLevel(context),
                        pageSpacing: 0.5,
                        enableTextSelection: true,
                      ),
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        width: 150.0,
                        height: 100.0,
                        child: Obx(
                          () => Row(
                            children: [
                              Tooltip(
                                message: 'Fit to Screen (Ctrl 0)',
                                child: IconButton(
                                  iconSize: 25.0,
                                  padding: EdgeInsets.zero,
                                  color: readCon.currentColor.value,
                                  onPressed: () {
                                    setState(
                                      () {
                                        _pdfViewerController.zoomLevel = computeZoomLevel(context);
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.fit_screen,
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: 'Zoom Out (Ctrl -)',
                                child: IconButton(
                                  iconSize: 25.0,
                                  padding: EdgeInsets.zero,
                                  color: readCon.currentColor.value,
                                  onPressed: () {
                                    setState(
                                      () {
                                        _pdfViewerController.zoomLevel -= 0.25;
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.zoom_out_sharp,
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: 'Zoom In (Ctrl +)',
                                child: IconButton(
                                  iconSize: 25.0,
                                  padding: EdgeInsets.zero,
                                  color: readCon.currentColor.value,
                                  onPressed: () {
                                    setState(
                                      () {
                                        _pdfViewerController.zoomLevel += 0.25;
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.zoom_in_sharp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  // retrieve the document controller to refresh the db
  DocumentController docCon = Get.find<DocumentController>();
  ReaderController readCon = Get.find<ReaderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: double.infinity,
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(
            width: 120.0,
            height: 50.0,
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
              icon: const Icon(Icons.desktop_mac_sharp, color: Colors.white70),
              label: const Text(
                "Save As",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200.0,
            height: 50.0,
            child: TextButton.icon(
              onPressed: () {
                readCon.saveAnnotations();
                readCon.clearPages();
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
    );
  }
}

// ignore: must_be_immutable
class _TopMenuBar extends StatefulWidget {
  const _TopMenuBar(
      {Key? key, required this.doc, required this.pdfViewerController})
      : super(key: key);

  final Document doc;
  final PdfViewerController pdfViewerController;

  @override
  State<_TopMenuBar> createState() => TopMenuBar();
}

class TopMenuBar extends State<_TopMenuBar> {
  DocumentController docCon = Get.find<DocumentController>();
  ReaderController readCon = Get.find<ReaderController>();
  late FavouriteController favCon;

  // constants for favourites icon of the document tile
  static Icon unfavouritedIcon = const Icon(
    Icons.star,
    color: Colors.yellow,
  );

  static Icon favouritedIcon = const Icon(
    Icons.star_border_outlined,
    color: Colors.white70,
  );

  // items list to populate background colours menu
  List<String> backgroundColourOptions = [
    "Dark",
    "White",
    "Sepia",
  ];

  @override
  void initState() {
    favCon = Get.put(FavouriteController(doc: widget.doc));
    super.initState();
  }

  @override
  void dispose() {
    favCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                readCon.savePageNumber(widget.pdfViewerController.pageNumber);
                readCon.saveAnnotations();
                docCon.removeMissingDocuments();
                Get.back();
              },
              icon: Transform.flip(
                flipX: true,
                child: const Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white70,
                ),
              ),
              label: const Text(
                "Back",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            PopupMenuButton<String>(
              initialValue: backgroundColourOptions[0],
              onSelected: (value) {
                readCon.updateBackgroundcolour(value);
              },
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return backgroundColourOptions.map(
                  (option) {
                    return PopupMenuItem<String>(
                      onTap: () {
                        readCon.updateBackgroundcolour(option);
                      },
                      child: SizedBox(
                        width: context.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.check,
                              color: Colors.blue,
                              size: readCon.backgroundColour.value != option
                                  ? 0.0
                                  : 20.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              offset: const Offset(0, 42),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.contrast,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    height: 50.0,
                    width: 10.0,
                  ),
                  Text(
                    "Background Colour",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // textbox
            TextButton.icon(
              onPressed: () async {
                // case if button is in a clicked state
                if (readCon.textBoxMode.value) {
                  // toggle boolean switch to false. the user wants to revert to normal mode
                  readCon.textBoxMode.value = false;
                } else {
                  // case if the button is in unclicked state
                  // toggle boolean switch to true. the user wants to revert to textBoxMode to add textboxes
                  readCon.textBoxMode.value = true;
                }
              },
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
            // draw
            TextButton.icon(
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
            // favourite
            TextButton.icon(
              onPressed: () {
                favCon.toggleFavourite();
              },
              icon: ValueListenableBuilder<Box<Document>>(
                valueListenable: docCon.recentFiles.listenable(),
                builder: (context, box, _) {
                  return box.get(widget.doc.docTitle)!.favourited
                      ? unfavouritedIcon
                      : favouritedIcon;
                },
              ),
              label: const Text(
                "Favourite",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
