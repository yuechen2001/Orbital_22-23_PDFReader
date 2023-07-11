import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_model.dart';
import '../../view/favourites_screen.dart';
import '../../view/folders_screen.dart';
import '../../view/home_screen.dart';
import '../../view/reader_screen.dart';

class SideNavigationBar extends StatelessWidget {
  SideNavigationBar({super.key, required this.currentPage});

  final String currentPage;
  final DocumentController docCon = Get.find<DocumentController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              if (currentPage != 'Home') {
                Get.offAll(const HomeScreen());
              }
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
              if (currentPage != 'Favourites') {
                Get.offAll(const FavouritesScreen());
              }
            },
          ),
          ListTile(
            title: Transform.translate(
              offset: const Offset(-20, 0),
              child: const Text(
                'Folders',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            leading: const Icon(
              Icons.folder_rounded,
              color: Colors.white70,
            ),
            onTap: () {
              if (currentPage != "Folders") {
                Get.offAll(const FoldersScreen());
              }
            },
          ),
        ],
      ),
    );
  }
}
