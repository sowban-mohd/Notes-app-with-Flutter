import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import '../../../logic/user_type_controller.dart';
import '/ui/widgets/obscreen_layout.dart';
import '../../../logic/page_controller.dart';

class OnboardingPage1 extends StatelessWidget {
  OnboardingPage1({super.key});

  //Gets access to page controller
  final _pageControllerX = Get.find<PageControllerX>();

  //Gets access to user type controller
  final _userTypeController = Get.find<UserTypeController>();

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen1.png'),
      title: 'Manage your notes easily',
      description: 'A completely easy way to manage and customize your notes.',
      currentPage: _pageControllerX.currentPageIndex.value,
      onNext: () {
        _pageControllerX.goToPage(1); // Navigate to second screen
      },
      onSkip: () {
        //Sets the initial location to notes screen
        _userTypeController.updateUserType('OnBoarded');
        Get.to(NotesScreen());
      },
    );
  }
}
