import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

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
                duration: Duration(days: 1),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Error in loading initial screen',
                      style: Styles.w400texts(
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                        onPressed: () => ref.refresh(initialLocationProvider),
                        child: Text('Retry',
                            style: Styles.boldTexts(
                                fontSize: 16.0, color: colorScheme.primary)))
                  ],
                )));
          });
          return SizedBox.shrink();
        });
  }
}
