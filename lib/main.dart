import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
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

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
      ),
      routerConfig: _router, // Uses GoRouter for navigation
      debugShowCheckedModeBanner: false, // Hides debug banner
    );
  }
}

// Defines the application's navigation routes using GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/', // Starting screen of the app
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          LoadingScreen(), // Loading screen before initial screen
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) =>
          OnboardingScreens(), // Onboarding screens for new users
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
      builder: (context, state) => NotesScreen(), // Main notes listing screen
    ),
    GoRoute(
      path: '/note',
      builder: (context, state) => NoteEditingscreen(), // Note editing screen
    )
  ],
);
