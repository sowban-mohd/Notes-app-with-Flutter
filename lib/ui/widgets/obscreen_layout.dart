import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:notetakingapp1/logic/controllers.dart';
import '../theme/styles.dart';

class OnboardingLayout extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  /// A reusable layout for onboarding screens
  OnboardingLayout({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onNext,
    this.onBack,
    this.onSkip,
  });

  final _pageControllerX = Get.find<PageControllerX>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar with Back and Skip buttons
            Padding(
              padding:
                  const EdgeInsets.all(12.0),
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
                            style: Styles.textButtonStyle(fontSize: 16.0),
                          ),
                        )
                      : const SizedBox.shrink(),
                  // Skip button (only if onSkip is provided)
                  onSkip != null
                      ? TextButton(
                          onPressed: onSkip,
                          child: Text("Skip",
                              style: Styles.textButtonStyle(fontSize: 16.0)),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),

            // Onboarding image section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: 360.0,
                height: 360.0,
                child: image,
              ),
            ),

            // Progress indicator bar
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    height: 5,
                    width: 99,
                    decoration: BoxDecoration(
                      color: _pageControllerX.currentPageIndex.value == index
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
              );
            }),

            const SizedBox(height: 36),

            // Title and description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Styles.titleStyle(fontSize: 33.0),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Styles.subtitleStyle(fontSize: 15.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Navigation button
            ElevatedButton(
              onPressed: onNext,
              style: Styles.elevatedButtonStyle(),
              child: Obx(
                () => Text(
                  _pageControllerX.currentPageIndex.value == 2
                      ? "Get Started"
                      : 'Next', // Last screen shows "Get Started"
                  style: Styles.elevatedButtonTextStyle(),
                ),
              ),
            ),
            const SizedBox(height: 42),
          ],
        ),
      ),
    );
  }
}
