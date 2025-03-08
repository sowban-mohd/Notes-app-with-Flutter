import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notetakingapp1/providers/initial_location_provider.dart';
import 'ui/screens/screens.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures Flutter bindings are initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wraps the app with Riverpod's ProviderScope for state management
  runApp(ProviderScope(child: NoteApp()));
}

class NoteApp extends ConsumerWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocation = ref.watch(initialLocationProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Hides debug banner
      routerConfig: GoRouter(
        initialLocation: initialLocation, // Starting screen of the app
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                LoadingScreen(), // A fallback Loading screen till initial screen loads
          ),
          GoRoute(
            path: '/welcome',
            builder: (context, state) =>
                OnboardingScreen(), // Onboarding screen for new users
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginScreen(), // Login screen
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => SignUpScreen(), // Signup screen
          ),
          GoRoute(
            path: '/password-reset',
            builder: (context, state) =>
                ForgotPasswordScreen(), // Password reset screen
          ),
          GoRoute(
            path: '/access-confirm',
            builder: (context, state) =>
                AccessConfirmationScreen(), // Access confirmation screen
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                NotesScreen(), // Main notes listing screen
          ),
          GoRoute(
            path: '/note',
            builder: (context, state) =>
                NoteEditingscreen(), // Note editing screen
          )
        ],
      ),
    );
  }
}
