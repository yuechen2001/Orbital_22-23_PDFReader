import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfreader2/models/document_model.dart';
import 'package:pdfreader2/view/home_screen.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

final List<Box> boxes = [];

// Function to register all Hive Models that we are using in our application
void _registerAdapter() {
  Hive.registerAdapter<Document>(DocumentAdapter());
}

// Establish connection to Hive
Future<List<Box>> _openBox() async {
  try {
    // Retrieve directory where all application data is stored in local storage
    var dir = await getApplicationDocumentsDirectory();
    print(dir.toString());

    Hive.init(dir.path);
    _registerAdapter();

    // Establish link to local storage
    var recentFiles = await Hive.openBox<Document>("recent_files");

    boxes.add(recentFiles);
    return boxes;
  } catch (error) {
    print("Error: $error");
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(home: HomeScreen());
  }
}
