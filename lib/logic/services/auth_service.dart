import 'package:firebase_auth/firebase_auth.dart';

/// Initializes Firebase Authentication Services
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp({required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
