import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier to manage current page and control the PageController
class PageNotifier extends StateNotifier<int> {
  final PageController pageController;

  PageNotifier(this.pageController) : super(0);

  void goToPage(int index) {
    state = index; //Update State
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth sliding transition
    );
  }
}

// Riverpod provider for the PageNotifier
final pageNotifierProvider = StateNotifierProvider<PageNotifier, int>((ref) {
  return PageNotifier(PageController(initialPage: 0));
});
