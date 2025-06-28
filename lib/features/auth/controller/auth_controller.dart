import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/auth/controller/password_strength_controller.dart';
import 'package:notetakingapp1/features/auth/models/password_strength.dart';
import 'package:notetakingapp1/features/auth/repository/auth_repository.dart';
import 'package:notetakingapp1/features/auth/models/auth_state.dart';

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

final userProvider =
    StreamProvider((ref) => ref.read(authRepositoryProvider).userStream());

final passwordStrengthProvider =
    NotifierProvider<PasswordStrengthController, PasswordStrength?>(
        PasswordStrengthController.new);

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

// Controller to handle authentication state and logic
class AuthController extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return AuthState(isLoading: false); //Initial State
  }

  Future<void> signup(String email, String password) async {
    state = AuthState(isLoading: true);

    final errorState = _validateCredentials(email, password);
    if (errorState != null) {
      state = errorState;
      return;
    }

    try {
      await _authRepository.signup(email, password);
      state = AuthState(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = _handleAuthError(e.code);
    } catch (e) {
      state = AuthState(
        generalError: 'An unexpected error occurred: ${e.toString()}',
        isLoading: false,
      );
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
      await _authRepository.login(email, password);
      state = AuthState(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = _handleAuthError(e.code);
    } catch (e) {
      state = AuthState(
        generalError: 'An unexpected error occurred: ${e.toString()}',
        isLoading: false,
      );
    }
  }

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
      await _authRepository.passwordreset(email);
      state = AuthState(
          successMessage: 'Password reset email sent', isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = _handleAuthError(e.code);
    } catch (e) {
      state = AuthState(
        generalError: 'An unexpected error occurred: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> logOut() async {
    state = AuthState(isLoading: true);

    try {
      await _authRepository.logOut();
      state = AuthState(isLoading: false);
    } catch (e) {
      state = AuthState(
        isLoading: false,
        generalError: 'Error signing out : ${e.toString()}',
      );
    }
  }

  void clearState() {
    state = AuthState(isLoading: false);
  }

  AuthState _handleAuthError(String errorCode) {
    String? emailError;
    String? passwordError;
    String? generalError;

    switch (errorCode) {
      case 'email-already-in-use':
        emailError = 'This email is already in use.';
        break;
      case 'invalid-credential':
        generalError = 'Invalid credentials';
        break;
      case 'user-not-found':
        passwordError = 'No account found with this email.';
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
        break;
    }

    return AuthState(
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      isLoading: false,
    );
  }

  AuthState? _validateCredentials(String email, String password) {
    final isEmailEmpty = email.isEmpty;
    final isPasswordEmpty = password.isEmpty;

    if (isEmailEmpty || isPasswordEmpty) {
      return AuthState(
        isLoading: false,
        emailError: isEmailEmpty ? 'Email cannot be empty.' : null,
        passwordError: isPasswordEmpty ? 'Password cannot be empty' : null,
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
          isLoading: false);
    }

    return null; // Indicating no state change occured
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
