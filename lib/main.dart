import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/access_confirmation_screen.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/login_screen.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/signup_screen.dart';
import 'package:notetakingapp1/ui/screens/loading_screen.dart';
import 'package:notetakingapp1/ui/screens/main_screens/homescreen.dart';
import 'package:notetakingapp1/ui/screens/obpageview.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures Flutter bindings are initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wraps the app with Riverpod's ProviderScope for state management
  runApp(DevicePreview(builder: (context) {
    return ProviderScope(child: NoteApp());
  },
  enabled: false,
  ));
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: DevicePreview.locale(context), // Sets the locale for the app
      builder: DevicePreview.appBuilder, // Enables device preview
      debugShowCheckedModeBanner: false, // Hides debug banner
      routerConfig: GoRouter(
        initialLocation: '/', // Starting screen of the app
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                LoadingScreen(), // A fallback Loading screen till initial screen loads
          ),
          GoRoute(
            path: '/welcome',
            builder: (context, state) =>
                OnboardingPageView(), // Onboarding screen for new users
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
                HomeScreen(), // Main notes listing screen
          )
        ],
      ),
    );
  }
}
