import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages, exposes the current page index and controls page controller in the Pageview
class PageNotifier extends AutoDisposeNotifier<int> {
  final PageController pageController = PageController();
  @override
  int build() => 0;

  /// Navigates to a new page
  void goToPage(int newPageIndex) {
    state = newPageIndex; //Update current page index
    pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth sliding transition
    );
  }
}

/// Provider of the PageNotifier
final pageNotifierProvider =
    NotifierProvider.autoDispose<PageNotifier, int>(PageNotifier.new);
