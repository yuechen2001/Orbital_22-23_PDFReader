import 'package:pdfreader2/models/document_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfreader2/screens/reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // change colour of appBar
        backgroundColor: const Color.fromARGB(255, 37, 47, 52),
        // leading: IconButton(
        //   onPressed: () {},
        //   // if needed, can change the icon
        //   icon: const Icon(Icons.menu),
        // ),
        title: const Text('PDF Reader'),
      ),
      body: Container(
          color: const Color.fromARGB(255, 61, 60, 57),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recent Documents",
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70)),
                Column(
                    children: Document.doc_list
                        .map((doc) => ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReaderScreen(doc)));
                              },
                              title: Text(
                                doc.doc_title!,
                                style:
                                    GoogleFonts.nunito(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                "${doc.page_num} Pages",
                                style:
                                    GoogleFonts.nunito(color: Colors.white70),
                              ),
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
                        .toList())
              ],
            ),
          )),
      drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 61, 60, 57),
          // add a list of buttons as child
          child: ListView(
            // remove any padding
            padding: EdgeInsets.zero,
            children: [
              // drawer header
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 37, 47, 52),
                ),
                child: Text("Menu", style: TextStyle(color: Colors.white70)),
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
