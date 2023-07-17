import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfreader2/view/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:window_manager/window_manager.dart';

import 'controllers/document_controller.dart';
import 'models/document_model.dart';
import 'constants/widgets/textbox_widget.dart';

final List<Box> boxes = [];

// Function to register all Hive Models that we are using in our application
void _registerAdapter() {
  Hive.registerAdapter<Document>(DocumentAdapter());
  Hive.registerAdapter<TextboxWidget>(TextboxWidgetAdapter());
}

// Establish connection to Hive
Future<List<Box>> _openBox() async {
  try {
    // Retrieve directory where all application data is stored in local storage
    var dir = await getApplicationDocumentsDirectory();

    Hive.init(dir.path);
    _registerAdapter();

    // Establish link to local storage
    var recentFiles = await Hive.openBox<Document>("recent_files");
    var existingFolders = await Hive.openBox<String>("existing_folders");

    boxes.add(recentFiles);
    boxes.add(existingFolders);
    return boxes;
  } catch (error) {
    rethrow;
  }
}

void main() async {
  await _openBox();
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1200, 750),
    windowButtonVisibility: true,
    fullScreen: false,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // init the document controller
    Get.put(DocumentController());
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => const HomeScreen(),
            transition: Transition.cupertino),
      ],
    );
  }
}
