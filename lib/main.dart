import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notetakingapp1/core/constants/constants.dart';
import 'package:notetakingapp1/core/constants/routes.dart';
import 'package:notetakingapp1/core/providers/shared_prefs_provider.dart';
import 'package:notetakingapp1/features/auth/ui/screens/access_confirmation_screen.dart';
import 'package:notetakingapp1/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:notetakingapp1/features/auth/ui/screens/login_screen.dart';
import 'package:notetakingapp1/features/auth/ui/screens/signup_screen.dart';
import 'package:notetakingapp1/features/notes/ui/screens/homescreen.dart';
import 'package:notetakingapp1/features/onboarding/ui/screens/obpageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures Flutter bindings are initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  // Wraps the app with Riverpod's ProviderScope for state management
  runApp(DevicePreview(
    builder: (context) {
      return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: NoteApp());
    },
    enabled: false,
  ));
}

class NoteApp extends ConsumerWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(sharedPreferencesProvider);
    return MaterialApp.router(
      locale: DevicePreview.locale(context), // Sets the locale for the app
      builder: DevicePreview.appBuilder, // Enables device preview
      debugShowCheckedModeBanner: false, // Hides debug banner
      routerConfig: GoRouter(
        initialLocation: prefs.getString(Constants.initialLocationKey) ??
            Routes.onBoardingScreen.path, // Starting screen of the app
        routes: [
          GoRoute(
            path: Routes.onBoardingScreen.path,
            builder: (context, state) =>
                OnboardingPageView(), // Onboarding screen for new users
          ),
          GoRoute(
            path: Routes.loginScreen.path,
            builder: (context, state) => LoginScreen(), // Login screen
          ),
          GoRoute(
            path: Routes.signUpScreen.path,
            builder: (context, state) => SignUpScreen(), // Signup screen
          ),
          GoRoute(
            path: Routes.passwordResetScreen.path,
            builder: (context, state) =>
                ForgotPasswordScreen(), // Password reset screen
          ),
          GoRoute(
            path: Routes.accessConfirmationScreen.path,
            builder: (context, state) =>
                AccessConfirmationScreen(), // Access confirmation screen
          ),
          GoRoute(
            path: Routes.homeScreen.path,
            builder: (context, state) =>
                HomeScreen(), // Main notes listing screen
          )
        ],
      ),
    );
  }
}
