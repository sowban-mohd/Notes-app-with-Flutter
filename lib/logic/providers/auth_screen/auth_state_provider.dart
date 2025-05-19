import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/firebase_providers.dart';
import 'package:notetakingapp1/logic/utils/auth_error_handler.dart';

/// Manages the Authentication State
class AuthState {
  final User? user;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final String? successMessage;
  final bool isLoading;

  AuthState(
      {this.user,
      this.emailError,
      this.passwordError,
      this.generalError,
      this.successMessage,
      required this.isLoading});
}

// Notifier to handle authentication state and logic
class AuthStateNotifier extends Notifier<AuthState> {
  FirebaseAuth get _auth => ref.read(authProvider);
  late final StreamSubscription<User?> _authSubscription;

  @override
  AuthState build() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      state = AuthState(isLoading: false, user: user);
    });

    ref.onDispose(() {
      _authSubscription.cancel();
    });

    return AuthState(isLoading: false);
  }

  Future<void> signup(String email, String password) async {
    state = AuthState(isLoading: true);

    final errorState = _validateCredentials(email, password);
    if (errorState != null) {
      state = errorState;
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      state = AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);

    final errorState = _validateCredentials(email, password);
    if (errorState != null) {
      state = errorState;
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      state = AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  /// Resets password for the given email
  Future<void> passwordreset(String email) async {
    state = AuthState(isLoading: true);

    if (email.isEmpty) {
      state = AuthState(emailError: 'Email cannot be empty.', isLoading: false);
      return;
    }

    if (!isValidEmail(email)) {
      state = AuthState(emailError: 'Invalid email format.', isLoading: false);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = AuthState(
          successMessage: 'Password reset email sent', isLoading: false);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      state = AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  /// Logs out the user
  Future<void> logOut() async {
    state = AuthState(isLoading: true);
    try {
      await _auth.signOut();
    } catch (e) {
      final currentUser = _auth.currentUser;
      state = AuthState(
          user: currentUser,
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

AuthState? _validateCredentials(String email, String password) {
  if (email.isEmpty || password.isEmpty) {
    return AuthState(
      emailError: email.isEmpty ? 'Email cannot be empty.' : null,
      passwordError: password.isEmpty ? 'Password cannot be empty.' : null,
      isLoading: false,
    );
  }

  if (!isValidEmail(email)) {
    return AuthState(
      emailError: 'Invalid email format.',
      isLoading: false,
    );
  }

  if (password.length < 6) {
    return AuthState(
      passwordError: 'Password must be at least 6 characters long.',
      isLoading: false,
    );
  }

  return null; // Valid
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

///Provider of AuthStateNotifier
final authStateProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);
