import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/providers/firebase_providers.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepository(auth: ref.read(authProvider)));

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository({required FirebaseAuth auth}) : _auth = auth;

  Stream<User?> userStream() {
    return _auth.authStateChanges();
  }

  Future<void> signup(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> passwordreset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
