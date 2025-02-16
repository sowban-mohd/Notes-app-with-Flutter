import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the Authentication State
class AuthState {
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final String? successMessage;
  final bool isLoading;

  AuthState(
      {this.emailError,
      this.passwordError,
      this.generalError,
      this.successMessage,
      required this.isLoading});
}

// Notifier to handle authentication state and logic
class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState(isLoading: false);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Clears the Authentication State
  void clearState() {
    state = AuthState(isLoading: false);
  }

  /// Logins or Signups(when the isSignUp is true) with given email and apssword
  Future<void> authenticate(String email, String password,
      {bool isSignup = false}) async {
    state = AuthState(isLoading: true);

    if (email.isEmpty || password.isEmpty) {
      state = AuthState(
        emailError: email.isEmpty ? 'Email cannot be empty.' : null,
        passwordError: password.isEmpty ? 'Password cannot be empty.' : null,
        isLoading: false,
      );
      return;
    }

    try {
      if (isSignup) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        state = AuthState(
            successMessage: 'Sign up is successful, Now login',
            isLoading: false);
      } else {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        state =
            AuthState(successMessage: 'Login is successful', isLoading: false);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Resets password for the given email
  Future<void> passwordreset(String email) async {
    state = AuthState(isLoading: true);

    if (email.isEmpty) {
      state = AuthState(emailError: 'Email cannot be empty.', isLoading: false);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = AuthState(
          successMessage: 'Password reset email sent', isLoading: false);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  ///Handles Firebase related error
  void _handleAuthError(FirebaseAuthException e) {
    String? emailError;
    String? passwordError;
    String? generalError;
    switch (e.code) {
      case 'email-already-in-use':
        emailError = 'This email is already in use.';
        break;
      case 'invalid-credential':
        generalError = 'Invalid credentials';
        break;
      case 'invalid-email':
        emailError = 'Please enter a valid email.';
        break;
      case 'weak-password':
        passwordError = 'Password is too weak.';
        break;
      case 'user-not-found':
        emailError = 'No account found with this email.';
        break;
      case 'wrong-password':
        passwordError = 'Incorrect password.';
        break;
      case 'user-disabled':
        emailError = 'Your account has been disabled.';
        break;
      case 'too-many-requests':
        generalError = 'Too many failed attempts.';
        break;
      case 'network-request-failed':
        generalError = 'Check your internet connection.';
        break;
      default:
        generalError = 'Something went wrong. Please try again.';
    }

    // Updates the State with errors if any
    state = AuthState(
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      isLoading: false,
    );
  }
}

///Provider of AuthStateNotifier
final authStateProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);
