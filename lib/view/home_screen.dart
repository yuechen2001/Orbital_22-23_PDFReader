import 'package:get/get.dart';
import 'package:pdfreader2/models/document_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfreader2/view/reader_screen.dart';

import '../constants/widgets/document_tile.dart';
import '../contorllers/document_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DocumentController docCon = Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // component 1: the button to open the drawer
            SizedBox(
              width: 20.0,
              height: double.infinity,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(1.0),
                      border: const BorderDirectional(
                          end: BorderSide(color: Colors.white10))),
                  child: Builder(builder: (BuildContext context) {
                    return IconButton(
                        icon: const Icon(Icons.arrow_right),
                        padding: EdgeInsets.zero,
                        color: Colors.white70,
                        onPressed: () {
                          // todo: add logic for toggling the buttons
                          if (Scaffold.of(context).isDrawerOpen) {
                            // if drawer opened
                            // close the drawer
                            Scaffold.of(context).closeDrawer();
                            // todo: change button orientation to face right
                          } else {
                            // if drawer closed
                            Scaffold.of(context).openDrawer();
                            // todo: change button orientation to face left
                          }
                        });
                  })),
            ),
            // component 2: the recent files screen to choose recent files
            Expanded(
                child: Container(
                    color: Colors.black87.withOpacity(1.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Text("Welcome",
                                  style: GoogleFonts.roboto(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70)),
                              Text("How can I help you today?",
                                  style: GoogleFonts.roboto(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70))
                            ],
                          ),
                          DecoratedBox(
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(
                                      bottom:
                                          BorderSide(color: Colors.white10))),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 15.0, 0.0, 20.0),
                                child: Text("Recent Files",
                                    style: GoogleFonts.roboto(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70)),
                              )),
                          GetBuilder<DocumentController>(builder: (context) {
                            return Column(
                                children: docCon.docList
                                    .map((doc) => DocumentTile(doc: doc))
                                    .toList());
                          })
                        ],
                      ),
                    ))),
          ]),
      drawer: Drawer(
          backgroundColor: Colors.black87.withOpacity(1.0),
          // add a list of buttons as child
          child: ListView(
            // remove any padding
            padding: EdgeInsets.zero,
            children: [
              // drawer header
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(1.0),
                    border: const BorderDirectional(
                        bottom: BorderSide(color: Colors.white10))),
                child:
                    const Text("Menu", style: TextStyle(color: Colors.white70)),
              ),
              ListTile(
                title:
                    const Text('Home', style: TextStyle(color: Colors.white70)),
                // todo: add logic for changing pages
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Files',
                    style: TextStyle(color: Colors.white70)),
                // todo: add logic for changing pages
                onTap: () async {
                  // parse the String
                  Document? doc = await docCon.createNewDocument();
                  if (doc != null) {
                    Get.to(ReaderScreen(doc: doc));
                  }
                },
              ),
              ListTile(
                  title: const Text('Favourites',
                      style: TextStyle(color: Colors.white70)),
                  // todo: add logic for changing pages
                  onTap: () {
                    Get.back();
                  }),
              ListTile(
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.white70)),
                  // todo: add logic for changing pages
                  onTap: () {
                    Get.back();
                  })
            ],
          )),
    );
  }
}
