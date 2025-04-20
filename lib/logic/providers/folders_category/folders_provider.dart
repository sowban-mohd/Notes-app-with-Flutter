import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('folders')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.data()).toList());
});
