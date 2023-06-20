import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:pdfreader2/pdfviewer.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/document_controller.dart';
import 'package:pdfreader2/controllers/favourite_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key, required this.doc}) : super(key: key);
  final Document doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReaderController readCon = Get.put(ReaderController());

  @override
  void dispose() {
    // dispose the reader controller
    readCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // component 1: the side menu
          const _SideBar(),
          Expanded(
            child: Column(
              children: [
                // component 2: the edit menu
                _TopMenuBar(doc: widget.doc),
                // component 3: the PDF view screen
                Flexible(
                  child: SfPdfViewer.file(
                    File(widget.doc.docPath),
                  ),
                )
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

  @override
  Widget build(BuildContext context) {
    return // todo: make this a sized box with infinite height
        Container(
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
  DocumentController docCon = Get.find<DocumentController>();
  late FavouriteController favCon;
  ReaderController readCon = Get.find<ReaderController>();

  // constants for favourites icon of the document tile
  static Icon unFavouritedIcon = const Icon(
    Icons.star,
    color: Colors.yellow,
  );

  static Icon favouritedIcon = const Icon(
    Icons.star_border_outlined,
    color: Colors.white70,
  );

  // items list to populate background colours menu
  List<String> backgroundColourOptions = [
    "White",
    "Dark",
    "Sepia",
  ];
  String selectedValue = "White";

  @override
  void initState() {
    favCon = Get.put(FavouriteController(doc: widget.doc));
    super.initState();
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
          // todo: add menu options
          children: [
            // textbox
            TextButton.icon(
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
            // background colour
            DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context).copyWith(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: DropdownButton2(
                  alignment: AlignmentDirectional.center,
                  value: selectedValue,
                  // isExpanded: true,
                  hint: const Text(
                    "Background Colour",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  items: backgroundColourOptions.map(
                    (option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          option,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0),
                        ),
                      );
                    },
                  ).toList(),
                  iconStyleData: const IconStyleData(iconSize: 0),
                  dropdownStyleData: const DropdownStyleData(
                    decoration: BoxDecoration(color: Colors.black87),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                    // update the readCon selectedValue field
                    readCon.updateBackgroundcolour(selectedValue);
                  },
                ),
              ),
            ),
            // text size
            TextButton.icon(
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
            // text font
            TextButton.icon(
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
              icon: ValueListenableBuilder(
                valueListenable: docCon.recentFiles.listenable(),
                builder: (context, box, _) {
                  return box.get(widget.doc.docTitle)!.favourited
                      ? favouritedIcon
                      : unFavouritedIcon;
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