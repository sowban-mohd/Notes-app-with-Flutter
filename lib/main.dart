import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notetakingapp1/logic/controllers.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';

void main() async {
  // Ensures Flutter bindings are initialized before Hive setup
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); //Hive Initialization
  await Hive.openBox('notes'); //Opening a hive box named 'notes'

  Get.put(UserTypeController()); //Controller that provides user type
  Get.put(NotesController()); //Controller that manages and provides note

  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  NoteApp({super.key});

  final UserTypeController _userTypeController = Get.find<UserTypeController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false, // Hides debug banner
        home: Obx(() {
          final userType = _userTypeController.userType.value;
          return userType == 'isLoading'
              ? LoadingScreen() // A blank fallback screen is displayed until the actual user type loads
              : userType == 'OnBoarded'
                  ? NotesScreen() // The main notes list screen is displayed if the user is already onboarded
                  : OnboardingScreen(); //Onboarding screen is displayed for new users
        }));
  }
}
