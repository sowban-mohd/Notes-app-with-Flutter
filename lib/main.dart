import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/screens/access_confirmation_screen.dart';
import 'package:notetakingapp1/screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/obscreens.dart';
import 'screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/notesscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: NoteApp()));
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnboardingScreens(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => NotesScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(path: '/access-confirm',
      builder: (context, state) => AccessConfirmationScreen(),
    ),
  ],
);
