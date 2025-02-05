import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// For tracking error messages
class AuthState {
  final String? emailError;
  final String? passwordError;
  final String? generalError;

  AuthState({this.emailError, this.passwordError, this.generalError});

  AuthState copyWith(
      {String? emailError, String? passwordError, String? generalError}) {
    return AuthState(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      generalError: generalError ?? this.generalError,
    );
  }
}

// StateNotifier to handle login logic
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = AuthState(
        emailError: email.isEmpty ? 'Email cannot be empty.' : null,
        passwordError: password.isEmpty ? 'Password cannot be empty.' : null,
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = AuthState(); // Clear errors on success
    } on FirebaseAuthException catch (e) {
      state = _handleAuthError(e);
    }
  }

  AuthState _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return state.copyWith(emailError: 'Please enter a valid email.');
      case 'user-not-found':
        return state.copyWith(emailError: 'No account found with this email.');
      case 'wrong-password':
        return state.copyWith(passwordError: 'Incorrect password.');
      case 'user-disabled':
        return AuthState(emailError: 'Your account has been disabled.');
      case 'too-many-requests':
        return AuthState(passwordError: 'Too many failed attempts.');
      case 'network-request-failed':
        return AuthState(generalError: 'Check your internet connection.');
      default:
        return AuthState(
            generalError: 'Something went wrong. Please try again.');
    }
  }
}

//Riverpod provider for authentication
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
