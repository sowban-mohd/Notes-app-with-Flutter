import 'package:flutter/material.dart';
import '../widgets/reusable_obscreen_layout.dart';
import 'package:go_router/go_router.dart';
import '../providers/page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen1 extends ConsumerWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider);

    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen1.png'),
      title: 'Manage your notes easily',
      description: 'A completely easy way to manage and customize your notes.',
      currentPage: currentPage,
      onNext: () {
        ref
            .read(pageNotifierProvider.notifier)
            .goToPage(1); // Navigate to second screen
      },
      onSkip: () {
        context.go('/LoginScreen');
      },
    );
  }
}
