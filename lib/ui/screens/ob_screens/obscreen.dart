import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/ui/screens/ob_screens/obpage1.dart';
import 'package:notetakingapp1/ui/screens/ob_screens/obpage2.dart';
import 'package:notetakingapp1/ui/screens/ob_screens/obpage3.dart';
import '../../../logic/page_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

   //Gets access to page controller
  final _pageControllerX = Get.find<PageControllerX>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageControllerX.pageController,
        children: [
          OnboardingPage1(),
          OnboardingPage2(),
          OnboardingPage3(),
        ],
      ),
    );
  }
}
