import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/providers/initial_location_provider.dart';
import 'package:notetakingapp1/ui/widgets/obscreen_layout.dart';
import '../../providers/page_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider); //Access to page index
    final pageNotifier = ref.read(pageNotifierProvider.notifier); //Access to methods for navigation in pageview
    final initialLocationNotifier = ref.read(initialLocationProvider.notifier); //Access to methods to change the initial location of the app
    
    ///Changes the initial location of the app to Login screen
    /// Navigates to login screen
    void skipToMain() {
      initialLocationNotifier.setInitialLocation('/login');
      context.go('/login');
    }

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageNotifier.pageController,
        children: [
          OnboardingLayout(
            image: Image.asset('assets/images/forobscreen1.png'),
            title: 'Manage your notes easily',
            description:
                'A completely easy way to manage and customize your notes.',
            currentPage: currentPage,
            onNext: () {
              ref
                  .read(pageNotifierProvider.notifier)
                  .goToPage(1); // Navigate to second screen
            },
            onSkip: () {
              skipToMain();
            },
          ),
          OnboardingLayout(
            image: Image.asset(
              'assets/images/forobscreen2.png',
            ),
            title: 'Organize your thoughts',
            description: 'Most beautiful note taking application.',
            currentPage: currentPage,
            onNext: () {
              ref
                  .read(pageNotifierProvider.notifier)
                  .goToPage(2); // Navigate to next screen
            },
            onBack: () {
              ref
                  .read(pageNotifierProvider.notifier)
                  .goToPage(0); // Navigate to previous screen
            },
            onSkip: () {
              skipToMain();
            },
          ),
          OnboardingLayout(
            image: Image.asset('assets/images/forobscreen3.png'),
            title: 'Create cards and easy styling',
            description: 'Making your content legible has never been easier.',
            currentPage: currentPage,
            onNext: () {
              skipToMain();
            },
            onBack: () {
              ref
                  .read(pageNotifierProvider.notifier)
                  .goToPage(1); // Navigate to previous screen
            },
          ),
        ],
      ),
    );
  }
}
