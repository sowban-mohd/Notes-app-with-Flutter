import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/firebase_providers.dart';

class FolderNotesOpsStateNotifier extends FamilyNotifier<String?, String> {
   FirebaseAuth get _auth => ref.read(authProvider);
  FirebaseFirestore get _firestore => ref.read(firestoreProvider);
  String? get _uid => _auth.currentUser?.uid;
  late final String folderName;
  late final CollectionReference<Map<String, dynamic>> collectionRef;

  @override
  String? build(String arg) {
    folderName = arg.replaceAll(' ', '').toLowerCase();
    collectionRef = _firestore
        .collection('users')
        .doc(_uid)
        .collection(folderName);
    return null;
  }

  /// Adds a note to the folder
  Future<void> addToFolder({required String title, required String content}) async {
    if (title.isEmpty && content.isEmpty) {
      return;
    }

    try {
      final note = {'title': title, 'content': content};
      final docRef = await collectionRef.add(note);
      await collectionRef.doc(docRef.id).set({
        'noteId': docRef.id,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Error adding note to folder: ${e.message}';
    }
  }

  /// Updates a note in the folder
  Future<void> updateInFolder({
    required String title,
    required String content,
    required String noteId,
  }) async {
    if (title.isEmpty && content.isEmpty) {
      return;
    }

    try {
      final note = {
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp()
      };
      await collectionRef.doc(noteId).set(note, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Error updating note in folder: ${e.message}';
    }
  }

  /// Deletes selected notes from the folder
  Future<void> removeFromFolder({required Set<String> noteIds}) async {
    final batch = _firestore.batch();

    try {
      for (final noteId in noteIds) {
        final docRef = collectionRef.doc(noteId);
        batch.delete(docRef);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      state = 'Error deleting notes from folder: ${e.message}';
    }
  }
}

final folderNotesOpsProvider =
    NotifierProvider.family<FolderNotesOpsStateNotifier, String?, String>(
        FolderNotesOpsStateNotifier.new);
