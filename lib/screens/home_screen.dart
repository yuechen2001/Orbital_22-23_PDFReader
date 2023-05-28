import 'package:pdfreader2/models/document_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfreader2/screens/reader_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // method that opens the local file system for users to pick files
  // this will be called once the file button is clicked/tapped
  Future<PlatformFile?> _pickFile() async {
    // open the storage for user to choose 1 pdf file
    // pickFiles parameter filters only for pdf files
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // gc: no file is picked => terminate early
    if (result == null) return null;
    // get the file
    PlatformFile file = result.files.first;
    // return the platform file
    return file;
  }

  // method to update the recent files list
  List<ListTile> _updateRecent() {
    return Document.docList
        .map((doc) => ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReaderScreen(doc)));
              },
              title: Text(
                doc.doc_title!,
                style: GoogleFonts.nunito(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
              // todo: add a size attribute
              trailing: Text(
                doc.doc_date!,
                style: GoogleFonts.nunito(color: Colors.grey),
              ),
              leading: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 32.0,
              ),
            ))
        .toList();
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
                          Column(children: _updateRecent())
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Files',
                    style: TextStyle(color: Colors.white70)),
                // todo: add logic for changing pages
                onTap: () {
                  // get the date and time
                  DateTime now = DateTime.now();
                  // format the date
                  String formattedDate =
                      DateFormat('EEEE, MMM d, yyyy').format(now);
                  // parse the String
                  _pickFile().then((file) {
                    // convert the file to a document object
                    Document doc =
                        Document(file?.name, file?.path, formattedDate);
                    // update the master doclist
                    Document.update(doc);
                    _updateRecent();
                    // open the file using the reader screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReaderScreen(doc)));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                  title: const Text('Favourites',
                      style: TextStyle(color: Colors.white70)),
                  // todo: add logic for changing pages
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.white70)),
                  // todo: add logic for changing pages
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          )),
    );
  }
}
