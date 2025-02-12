import 'package:flutter/material.dart';
import '../../widgets/reusable_obscreen_layout.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/ob_screen_providers/page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen2 extends ConsumerWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider);

    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen2.png',),
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
        context.go('/login');
      },
    );
  }
}
