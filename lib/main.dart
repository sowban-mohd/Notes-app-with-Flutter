import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notetakingapp1/logic/state_controllers.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';

void main() async {
  // Ensures Flutter bindings are initialized before Hive setup
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); //Hive Initialization
  await Hive.openBox('PinnedNotes'); //Opening a hive box named 'PinnedNotes' which stores all user's pinned notes
  await Hive.openBox('OtherNotes'); // Box for rest of the notes

  Get.put(UserTypeController());
  Get.put(PageControllerX());
  Get.lazyPut(() => NotesController());
  Get.lazyPut(() => SearchControllerX());
  Get.lazyPut(() => SelectedNotesController());
  
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false, // Hides debug banner
        home:
            LoadingScreen() // Loading screen decides which screen to load based on the user type
        );
  }
}
