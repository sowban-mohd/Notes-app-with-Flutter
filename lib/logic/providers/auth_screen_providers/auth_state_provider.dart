import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/services/auth_service.dart';
import 'package:notetakingapp1/logic/utils/auth_error_handler.dart';

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

  final AuthService _authService = AuthService();

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
        await _authService.signUp(email: email, password: password);
        state = AuthState(isLoading: false, successMessage: 'Sign up is successful. Now login');
      } else {
        await _authService.login(email: email, password: password);
        state = AuthState(isLoading: false);
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
      await _authService.resetPassword(email);
      state = AuthState(
          successMessage: 'Password reset email sent', isLoading: false);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Logs out the user
  Future<void> logOut() async {
    try {
      await _authService.logout();
    } catch (e) {
      state = AuthState(
          isLoading: false,
          generalError: 'Error signing out : ${e.toString()}');
    }
  }

  /// Clears the Authentication State
  void clearState() {
    state = AuthState(isLoading: false);
  }

  ///Handles Firebase related error
  void _handleAuthError(FirebaseAuthException e) {
    final errors = handleAuthError(e.code);

    state = AuthState(
      emailError: errors['emailError'],
      passwordError: errors['passwordError'],
      generalError: errors['generalError'],
      isLoading: false,
    );
  }
}

///Provider of AuthStateNotifier
final authStateProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);
