import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/user_type_controller.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import '/ui/widgets/obscreen_layout.dart';
import '../../../logic/page_controller.dart';

class OnboardingPage3 extends StatelessWidget {
  OnboardingPage3({super.key});

  //Gets access to page controller
  final _pageControllerX = Get.find<PageControllerX>();

  //Gets access to user type controller
  final _userTypeController = Get.find<UserTypeController>();

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen3.png'),
      title: 'Create cards and easy styling',
      description: 'Making your content legible has never been easier.',
      currentPage: _pageControllerX.currentPageIndex.value,
      onNext: () {
        //Sets the initial location to notes screen
        _userTypeController.updateUserType('OnBoarded');
        Get.to(NotesScreen());
      },
      onBack: () {
        _pageControllerX.goToPage(1); //Navigates to second screen
      },
    );
  }
}
