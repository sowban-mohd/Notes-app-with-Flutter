import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable layout for onboarding screens
class OnboardingLayout extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingLayout({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.onNext,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar with Back and Skip buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only if onBack is provided)
                  onBack != null
                      ? TextButton.icon(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.blue),
                          label: Text(
                            "Back",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  // Skip button (only if onSkip is provided)
                  onSkip != null
                      ? TextButton(
                          onPressed: onSkip,
                          child: Text(
                            "Skip",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  height: 5,
                  width: 99,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color.fromRGBO(58, 133, 247, 1) // Active step
                        : const Color.fromRGBO(206, 203, 211, 1), // Inactive steps
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
            const SizedBox(height: 36),

            // Title and description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 33.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      color: Colors.black.withValues(alpha: 51.0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Navigation button
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(304, 56),
                backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                currentPage == 2 ? "Get Started" : 'Next', // Last screen shows "Get Started"
                style: GoogleFonts.nunitoSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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