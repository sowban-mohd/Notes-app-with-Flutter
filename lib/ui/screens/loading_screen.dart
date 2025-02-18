import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../providers/initial_location_provider.dart';
import 'package:go_router/go_router.dart';

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

      error: (error, stackTrace) => const Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}
