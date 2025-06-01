import 'dart:async';
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

    state = await _authRepository.signup(email, password);
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);

    final errorState = _validateCredentials(email, password);
    if (errorState != null) {
      state = errorState;
      return;
    }

    state = await _authRepository.login(email, password);
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

    state = await _authRepository.passwordreset(email);
  }

  /// Logs out the user
  Future<void> logOut() async {
    state = AuthState(isLoading: true);
    state = await _authRepository.logOut();
  }

  /// Clears the Authentication State
  void clearState() {
    state = AuthState(isLoading: false);
  }

  AuthState? _validateCredentials(String email, String password) {
    if (email.isEmpty) {
      return AuthState(isLoading: false, emailError: 'Email cannot be empty.');
    }
    if (password.isEmpty) {
      return AuthState(
          isLoading: false, passwordError: 'Password cannot be empty');
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
