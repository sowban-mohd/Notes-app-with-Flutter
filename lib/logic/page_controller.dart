import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// GetX controller that manages, exposes the current page index and controls page controller in the Pageview
class PageControllerX extends GetxController {
  final PageController pageController = PageController();
  final currentPageIndex = 0.obs;

  /// Navigates to a new page
  void goToPage(int newPageIndex) {
    currentPageIndex.value = newPageIndex; //Update current page index
    pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth sliding transition
    );
  }
}