import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/providers/firebase_providers.dart';
import 'package:notetakingapp1/features/auth/models/auth_state.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepository(auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository({required FirebaseAuth auth}) : _auth = auth;


   Stream<User?> userStream(){
    return _auth.authStateChanges();
   }
   
  Future<AuthState> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthState(isLoading: false);
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  Future<AuthState> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthState(isLoading: false);
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  /// Resets password for the given email
  Future<AuthState> passwordreset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthState(
          successMessage: 'Password reset email sent', isLoading: false);
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return AuthState(
          generalError: 'An unexpected error occurred: ${e.toString()}',
          isLoading: false);
    }
  }

  /// Logs out the user
  Future<AuthState> logOut() async {
    try {
      await _auth.signOut();
      return AuthState(isLoading: false);
    } catch (e) {
      return AuthState(
          isLoading: false,
          generalError: 'Error signing out : ${e.toString()}');
    }
  }

  ///Handles Firebase related error
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
}
