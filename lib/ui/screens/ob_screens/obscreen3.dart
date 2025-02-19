import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/providers/initial_location_provider.dart';
import '/ui/widgets/obscreen_layout.dart';
import '/providers/ob_screen_providers/page_provider.dart';

class OnboardingScreen3 extends ConsumerWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Gets access to current page index
    final currentPage = ref.watch(pageNotifierProvider);
    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen3.png'),
      title: 'Create cards and easy styling',
      description: 'Making your content legible has never been easier.',
      currentPage: currentPage,
      onNext: () {
        //Sets the initial location to login screen
        ref.read(initialLocationProvider.notifier).setInitialLocation('/login');
        context.go('/login');
      },
      onBack: () {
        ref
            .read(pageNotifierProvider.notifier)
            .goToPage(1); // Navigate to previous screen
      },
    );
  }
}
