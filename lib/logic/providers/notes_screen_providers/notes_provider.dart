import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider = StreamProvider.autoDispose((ref) {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('notes')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});
