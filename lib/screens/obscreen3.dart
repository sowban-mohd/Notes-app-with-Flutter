import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../page_notifier.dart';

class OnboardingScreen3 extends ConsumerWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      ref.read(pageNotifierProvider.notifier).goToPage(1);
                    },
                    icon:
                        const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
                    label: Text(
                      "Back",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0, top: 88.0, bottom: 8.0),
                  child: Image.asset(
                    'assets/images/forobscreen3.png',
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: 5,
                      width: 98, // Width of the SizedBox
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Color.fromRGBO(58, 133, 247, 1)
                            : Color.fromRGBO(206, 203, 211, 1),
                        borderRadius: index == 0
                            ? BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              )
                            : index == 2
                                ? BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  )
                                : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 54.0),
                  child: Text(
                    'Create cards and easy styling',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Making your content legible has never been easier.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: Colors.black.withValues(
                        alpha: 51,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Handle Next action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(304, 56),
                    backgroundColor: Color.fromRGBO(0, 122, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
