import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/initial_screen_provider.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocation = ref.watch(initialLocationProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialLocation.whenData((location) {
        context.go(location); // Navigate once loaded
      });
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Colors.blue,)),
    );
  }
}
