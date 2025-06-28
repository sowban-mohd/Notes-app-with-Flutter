import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/constants.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/core/providers/shared_prefs_provider.dart';
import 'package:notetakingapp1/features/onboarding/ui/components/obscreen_layout.dart';

class OnboardingPageView extends ConsumerStatefulWidget {
  const OnboardingPageView({super.key});

  @override
  ConsumerState<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends ConsumerState<OnboardingPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _skipToMain() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final goRouterContext = GoRouter.of(context);
    await prefs.setString(
        Constants.initialLocationKey, Routes.loginScreen.path);
    goRouterContext.go(Routes.loginScreen.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingLayout(
            pageIndex: 0,
            image: Image.asset('assets/images/forobscreen1.png'),
            title: 'Manage your notes easily',
            description:
                'A completely easy way to manage and customize your notes.',
            onNext: () => _goToPage(1),
            onSkip: _skipToMain,
          ),
          OnboardingLayout(
            pageIndex: 1,
            image: Image.asset('assets/images/forobscreen2.png'),
            title: 'Organize your thoughts',
            description: 'Most beautiful note taking application.',
            onNext: () => _goToPage(2),
            onBack: () => _goToPage(0),
            onSkip: _skipToMain,
          ),
          OnboardingLayout(
            pageIndex: 2,
            image: Image.asset('assets/images/forobscreen3.png'),
            title: 'Create cards and easy styling',
            description: 'Making your content legible has never been easier.',
            onNext: _skipToMain,
            onBack: () => _goToPage(1),
          ),
        ],
      ),
    );
  }
}
