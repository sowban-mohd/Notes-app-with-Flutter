import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final folderNotesProvider = StreamProvider.family
    .autoDispose<List<Map<String, dynamic>>, String>((ref, folderName) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  final folder = folderName.replaceAll(' ', '').toLowerCase();
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(folder)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => doc.data()).toList());
});
