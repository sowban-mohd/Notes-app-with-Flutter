import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteOpsStateNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  ///Adds note
  Future<void> addNote({required String title, required String content}) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('notes');

    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      final note = {'title': title, 'content': content, 'pinned': false};
      final docRef = await collectionRef.add(note);
      await collectionRef.doc(docRef.id).set({
        'noteId': docRef.id,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Failed to add note : ${e.toString()}';
    }
  }

  /// Updates note
  Future<void> updateNote({
    required String title,
    required String content,
    required String noteId,
    bool? pinned,
  }) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('notes');

    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      final note = {
        'title': title,
        'content': content,
        'pinned': pinned,
        'timestamp': FieldValue.serverTimestamp()
      };
      await collectionRef.doc(noteId).set(note, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Failed to update note : ${e.toString()}';
    }
  }

  /// Deletes selected notes
  Future<void> deleteNote({required Set<String> noteIds}) async {
    final batch = _firestore.batch();
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('notes');

    try {
      for (final noteId in noteIds) {
        final docRef = collectionRef.doc(noteId);
        batch.delete(docRef);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      state = 'Failed to delete notes : ${e.toString()}';
    }
  }

  /// Pin note
  Future<void> pinNote(Set<String> noteIds) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('notes');

    for (var noteId in noteIds) {
      final updatedNote = {'pinned': true};
      await collectionRef.doc(noteId).set(updatedNote, SetOptions(merge: true));
    }
  }

  /// Unpin note
  Future<void> unPinNote(Set<String> noteIds) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('notes');

    for (var noteId in noteIds) {
      final updatedNote = {'pinned': false};
      await collectionRef.doc(noteId).set(updatedNote, SetOptions(merge: true));
    }
  }
}

final noteOpsStateProvider =
    NotifierProvider<NoteOpsStateNotifier, String?>(NoteOpsStateNotifier.new);
