import 'package:flutter/material.dart';
import 'package:notetakingapp1/core/theme/styles.dart';

class OnboardingLayout extends StatelessWidget {
  final int pageIndex;
  final Widget image;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  /// A reusable layout for onboarding screens

  const OnboardingLayout({
    super.key,
    required this.pageIndex,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(children: [
          // Top navigation bar with Back and Skip buttons
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (only if onBack is provided)
                onBack != null
                    ? TextButton.icon(
                        onPressed: onBack,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          "Back",
                          style: Styles.textButtonStyle(fontSize: 14.0),
                        ),
                      )
                    : const SizedBox.shrink(),
                // Skip button (only if onSkip is provided)
                onSkip != null
                    ? TextButton(
                        onPressed: onSkip,
                        child: Text("Skip",
                            style: Styles.textButtonStyle(fontSize: 14.0)),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),

          Flexible(
              child: SizedBox(
                  height:
                      screenHeight * 0.1)), // Space between top bar and image

          // Onboarding image section
          SizedBox(height: 300.0, width: 300.0, child: image),

          SizedBox(height: 20),

          // Progress indicator bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                height: 5,
                width: 88,
                decoration: BoxDecoration(
                  color: pageIndex == index
                      ? const Color.fromRGBO(58, 133, 247, 1) // Active step
                      : const Color.fromRGBO(
                          206, 203, 211, 1), // Inactive steps
                  borderRadius: index == 0
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        )
                      : index == 2
                          ? const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            )
                          : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 28),

          SizedBox(
            width: 260,
            height: 200,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Styles.titleStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Styles.subtitleStyle(fontSize: 12.0),
                ),
                Spacer(),
                // Navigation button
                ElevatedButton(
                  onPressed: onNext,
                  style: Styles.elevatedButtonStyle(),
                  child: Text(
                    pageIndex == 2
                        ? "Get Started"
                        : 'Next', // Last screen shows "Get Started"
                    style: Styles.elevatedButtonTextStyle(),
                  ),
                ),
              ],
            ),
          ),

          Flexible(child: const SizedBox(height: 60)),
        ]),
      ),
    );
  }
}
