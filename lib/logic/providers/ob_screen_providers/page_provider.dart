import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier to manage current page and control the PageController
class PageNotifier extends Notifier<int> {
  final PageController pageController = PageController();

  @override
  int build() => 0;

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
final pageNotifierProvider =
    NotifierProvider<PageNotifier, int>(PageNotifier.new);
