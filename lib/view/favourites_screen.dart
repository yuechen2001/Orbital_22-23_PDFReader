import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/models/document_model.dart';

import 'package:flutter/material.dart';
import 'package:pdfreader2/view/reader_screen.dart';

import '../constants/widgets/document_tile.dart';
import '../controllers/document_controller.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final DocumentController docCon = Get.find<DocumentController>();

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
              child: Builder(
                builder: (BuildContext context) {
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
                    },
                  );
                },
              ),
            ),
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
                    const Column(
                      children: [
                        Text("Favourites",
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70)),
                        Text("All your most important documents in one place.",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70))
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      child: Text("Favourited Files",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white),
                    ValueListenableBuilder(
                      valueListenable: docCon.recentFiles.listenable(),
                      builder: (context, Box<Document> box, _) {
                        if (box.values.isEmpty) {
                          return const Center(
                            child: Text("No Documents Found"),
                          );
                        }
                        final sorted = box.values
                            .where((doc) => doc.favourited)
                            .toList()
                          ..sort(
                              (a, b) => b.lastOpened.compareTo(a.lastOpened));
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: sorted.length,
                          itemBuilder: (context, index) {
                            Document doc = sorted[index];
                            return DocumentTile(
                              doc: doc,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(color: Colors.white10);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black87.withOpacity(1.0),
        // add a list of buttons as child
        child: ListView(
          // remove any padding
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () {},
            ),
            ListTile(
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              leading: const Icon(
                Icons.home_rounded,
                color: Colors.white70,
              ),
              onTap: () {
                Get.toNamed('/');
              },
            ),
            ListTile(
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: const Text(
                  'Upload File',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              leading: const Icon(
                Icons.file_upload_outlined,
                color: Colors.white70,
              ),
              onTap: () async {
                // parse the String
                Document? doc = await docCon.createNewDocument();
                if (doc != null) {
                  Get.to(ReaderScreen(doc: doc));
                }
              },
            ),
            ListTile(
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: const Text(
                  'Favourites',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              leading: const Icon(
                Icons.favorite,
                color: Colors.white70,
                size: 20.0,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: const Text(
                  'Folder',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              leading: const Icon(
                Icons.folder_rounded,
                color: Colors.white70,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
