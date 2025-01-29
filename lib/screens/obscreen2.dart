import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../page_notifier.dart';

class OnboardingScreen2 extends ConsumerWidget {
  const OnboardingScreen2({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      ref.read(pageNotifierProvider.notifier).goToPage(0);
                    },
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
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle Skip action
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0, top: 46.0),
                  child: Image.asset(
                    'assets/images/forobscreen2.png',
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
                    'Organize your thoughts',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Most beautiful note taking application.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Colors.black.withValues(
                      alpha: 51,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    ref.read(pageNotifierProvider.notifier).goToPage(2);
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
