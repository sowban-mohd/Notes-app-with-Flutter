import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/initial_location_provider.dart';
import '../../../providers/ob_screen_providers/page_provider.dart';
import 'obscreen1.dart';
import 'obscreen2.dart';
import 'obscreen3.dart';

class OnboardingScreens extends ConsumerWidget {
  const OnboardingScreens({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Gets access to the page notifier 
    final pageNotifier = ref.read(pageNotifierProvider.notifier);

    //Sets the initial location to login screen
    ref.read(initialLocationProvider.notifier).setInitialLocation('/login');

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageNotifier.pageController,
        children: [
          OnboardingScreen1(),
          OnboardingScreen2(),
          OnboardingScreen3(),
        ],
      ),
    );
  }
}
