import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/access_confirmation_screen.dart';
import 'package:notetakingapp1/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:notetakingapp1/ui/screens/loading_screen.dart';
import 'package:notetakingapp1/ui/screens/notes_screens/noteeditingscreen.dart';
import 'ui/screens/auth_screens/login_screen.dart';
import 'ui/screens/ob_screens/obscreens.dart';
import 'ui/screens/auth_screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/notes_screens/notesscreen.dart';
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
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => OnboardingScreens(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/access-confirm',
      builder: (context, state) => AccessConfirmationScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => NotesScreen(),
    ),
    GoRoute(
      path: '/note',
      builder: (context, state) => NoteEditingscreen(),
    )
  ],
);
