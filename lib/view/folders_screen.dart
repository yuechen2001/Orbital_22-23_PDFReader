import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfreader2/controllers/folders_controller.dart';

import 'package:flutter/material.dart';

import '../constants/widgets/folder_tile.dart';
import '../constants/widgets/side_navigation_bar.dart';
import '../controllers/document_controller.dart';

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
                              child: Text(
                                "No Folders Found.",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(color: Colors.white10);
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              final TextEditingController textCon =
                                  TextEditingController();
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(221, 39, 38, 38),
                                  elevation: 24.0,
                                  title: const Text(
                                    'Name Your New Folder: ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  content: TextFormField(
                                    autofocus: true,
                                    controller: textCon,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        hintText: 'E.g. My Favourite Books',
                                        hintStyle: TextStyle(
                                            color: Colors.white70
                                                .withOpacity(0.2))),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        folderCon.createNewFolder(textCon.text);
                                        Get.back();
                                      },
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: SideNavigationBar(currentPage: "Folders"));
  }
}
