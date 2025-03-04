import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/user_type_controller.dart';
import 'package:notetakingapp1/ui/screens/notesscreen.dart';
import 'package:notetakingapp1/ui/widgets/obscreen_layout.dart';
import '../../logic/page_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final _userTypeController =
      Get.find<UserTypeController>(); //Controller that provides user type

  final _pageControllerX =
      Get.put(PageControllerX()); //Controller that manages pages in ob pageview

  ///Navigates to main note listing screen after updating the user type to 'OnBoarded'
  void _skipToMain() {
    _userTypeController.updateUserType('OnBoarded');
    Get.delete<
        PageControllerX>(); //Remove controller from memory once onboarding is completed
    Get.off(() => NotesScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageControllerX.pageController,
        children: [
          Obx(() {
            return OnboardingLayout(
              image: Image.asset('assets/images/forobscreen1.png'),
              title: 'Manage your notes easily',
              description:
                  'A completely easy way to manage and customize your notes.',
              currentPage: _pageControllerX.currentPageIndex.value,
              onNext: () =>
                  _pageControllerX.goToPage(1), // Navigate to second screen
              onSkip: () => _skipToMain(),
            );
          }),
          Obx(() {
            return OnboardingLayout(
              image: Image.asset(
                'assets/images/forobscreen2.png',
              ),
              title: 'Organize your thoughts',
              description: 'Most beautiful note taking application.',
              currentPage: _pageControllerX.currentPageIndex.value,
              onNext: () =>
                  _pageControllerX.goToPage(2), // Navigates to third screen
              onBack: () =>
                  _pageControllerX.goToPage(0), //Navigates to first screen
              onSkip: () => _skipToMain(),
            );
          }),
          Obx(() {
            return OnboardingLayout(
              image: Image.asset('assets/images/forobscreen3.png'),
              title: 'Create cards and easy styling',
              description: 'Making your content legible has never been easier.',
              currentPage: _pageControllerX.currentPageIndex.value,
              onNext: () => _skipToMain(),
              onBack: () =>
                  _pageControllerX.goToPage(1), //Navigates to second screen
            );
          }),
        ],
      ),
    );
  }
}
