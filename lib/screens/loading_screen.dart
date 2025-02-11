import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/initial_location_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocation = ref.watch(initialLocationProvider);

    return initialLocation.when(
        data: (location) {
          // Navigate to the resolved location
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(location);
          });
          return const Scaffold(
            backgroundColor: Colors.white,
          );
        },
        // Return a temporary loading UI while navigation happens
        loading: () => const Scaffold(
              backgroundColor: Colors.white,
            ),

        // Display error message and a button to retry
        error: (error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'An error occured',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                  ),
                ),
                TextButton(
                    onPressed: () => ref.refresh(initialLocationProvider),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.nunito(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ))
              ],
            )));
          });
          return SizedBox.shrink();
        });
  }
}
