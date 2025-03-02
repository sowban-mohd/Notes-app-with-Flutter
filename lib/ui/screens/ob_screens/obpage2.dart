import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/user_type_controller.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import '/ui/widgets/obscreen_layout.dart';
import '../../../logic/page_controller.dart';

class OnboardingPage2 extends StatelessWidget {
  OnboardingPage2({super.key});

  //Gets access to page controller
  final _pageControllerX = Get.find<PageControllerX>();

  //Gets access to user type controller
  final _userTypeController = Get.find<UserTypeController>();

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      image: Image.asset(
        'assets/images/forobscreen2.png',
      ),
      title: 'Organize your thoughts',
      description: 'Most beautiful note taking application.',
      currentPage: _pageControllerX.currentPageIndex.value,
      onNext: () {
        _pageControllerX.goToPage(2); // Navigates to third screen
      },
      onBack: () {
        _pageControllerX.goToPage(0); //Navigates to first screen
      },
      onSkip: () {
        //Sets the initial location to notes screen
        _userTypeController.updateUserType('OnBoarded');
        Get.to(NotesScreen());
      },
    );
  }
}
