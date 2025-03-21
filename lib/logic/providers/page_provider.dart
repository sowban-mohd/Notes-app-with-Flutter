import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages, exposes the current page index and controls page controller in the Pageview
class PageNotifier extends AutoDisposeNotifier<int> {
  final PageController pageController = PageController();

  @override
  int build() {
    ref.onDispose(() {
      pageController.dispose();
    });
    return 0;
  }

  void goToPage(int newPageIndex) {
    state = newPageIndex;
    pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

/// Provider of the PageNotifier
final pageNotifierProvider =
    NotifierProvider.autoDispose<PageNotifier, int>(PageNotifier.new);
