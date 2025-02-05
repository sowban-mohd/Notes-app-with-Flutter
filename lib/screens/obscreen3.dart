import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/widgets/reusable_ob_layout.dart';
import '../providers/page_notifier.dart';

class OnboardingScreen3 extends ConsumerWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider);
    return OnboardingLayout(
      image: Image.asset('assets/images/forobscreen3.png'),
      title: 'Create cards and easy styling',
      description: 'Making your content legible has never been easier.',
      currentPage: currentPage,
      onNext: () {
       context.go('/LoginScreen');
      },
      onBack: () {
        ref
            .read(pageNotifierProvider.notifier)
            .goToPage(1); // Navigate to previous screen
      },
    );
  }
}
