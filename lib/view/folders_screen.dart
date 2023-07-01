import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/folders_controller.dart';
import 'package:pdfreader2/models/document_model.dart';

import 'package:flutter/material.dart';
import 'package:pdfreader2/view/favourites_screen.dart';
import 'package:pdfreader2/view/reader_screen.dart';

import '../constants/widgets/document_tile.dart';
import '../constants/widgets/folder_tile.dart';
import '../controllers/document_controller.dart';
import 'home_screen.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  final DocumentController docCon = Get.find<DocumentController>();
  final FoldersController folderCon = Get.put(FoldersController());

  @override
  void dispose() {
    folderCon.dispose();
    super.dispose();
  }

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
                        Text("Folders",
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70)),
                        Text("Stay organised, stay winning.",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70))
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      child: Text("Your Folders",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70)),
                    ),
                    const Divider(color: Colors.white),
                    ValueListenableBuilder(
                      valueListenable: folderCon.existingFolders.listenable(),
                      builder: (context, Box<String> box, _) {
                        if (box.values.isEmpty) {
                          return const Center(
                            child:
                                Text("No Folders Found. Create a new one now!"),
                          );
                        }
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: box.values.length,
                          itemBuilder: (context, index) {
                            String name = box.values.elementAt(index);
                            return FolderTile(folderName: name);
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
                Get.to(const HomeScreen());
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
                Get.to(const FavouritesScreen());
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
                Get.to(const FoldersScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
