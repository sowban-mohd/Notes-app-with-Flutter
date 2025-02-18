import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages Note Deletion State
class DeleteState {
  final bool isLoading;
  final String? errorMessage;

  DeleteState({required this.isLoading, this.errorMessage});
}

/// Notifier that manages and exposes note deletion state
class DeleteNoteNotifier extends Notifier<DeleteState> {
  @override
  DeleteState build() => DeleteState(isLoading: false);

  /// Deletes selected notes
  Future<void> deleteNote(Set<String> noteIds) async {
    state = DeleteState(isLoading: true);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String? error;

    try {
      //Enables firebase batch opeartions
      final batch = firestore.batch();

      for (final noteId in noteIds) {
        final noteRef = firestore
            .collection('users')
            .doc(uid)
            .collection('notes')
            .doc(noteId);

        //Queues delete operation for each notes with noteIds from the list inside user's notes collection
        batch.delete(noteRef);
      }
      //Performs queued batch operations
      await batch.commit();
    }
    //Handles Firebase errors
    on FirebaseException catch (e) {
      error = 'Failed to delete notes : ${e.message}';
    }
    state = DeleteState(isLoading: false, errorMessage: error);
  }
}

/// Provider of DeleteNoteNotifier
final deleteNoteProvider =
    NotifierProvider<DeleteNoteNotifier, DeleteState>(DeleteNoteNotifier.new);
