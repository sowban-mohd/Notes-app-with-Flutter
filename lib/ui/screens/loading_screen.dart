import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:notetakingapp1/logic/user_type_controller.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  final UserTypeController userTypeController = Get.find<UserTypeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userType = userTypeController.userType.value;
      final error = userTypeController.error.value;

      //Checks the error case in loading user type from shared preferences storage
      if (error.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(days: 1),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Error in loading initial screen',
                      style: Styles.w400texts(fontSize: 16.0)),
                  TextButton(
                    onPressed: () => userTypeController.retry(),
                    child: Text('Retry',
                        style: Styles.boldTexts(
                            color: Colors.blue, fontSize: 16.0)),
                  )
                ],
              ),
            ),
          );
        });
        return const Scaffold(
          backgroundColor: Colors.white,
        );
      }

      // Navigate to resolved location once data is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (userType == 'New User') {
          Get.offAll(() =>
              OnboardingPageView()); //If user is new navigate to onboarding pageview
        } else if (userType == 'OnBoarded') {
          Get.offAll(() =>
              NotesScreen()); //If user is already onboarded navigate to home screen
        }
      });
      return const Scaffold(backgroundColor: Colors.white);
    });
  }
}
