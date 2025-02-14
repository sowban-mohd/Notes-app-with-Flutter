import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteState {
  final bool isLoading;
  final String? errorMessage;

  DeleteState({required this.isLoading, this.errorMessage});
}

class DeleteNoteNotifier extends Notifier<DeleteState> {
  @override
  DeleteState build() => DeleteState(isLoading: false);

  Future<void> deleteNote(List<String> noteIds) async {
    state = DeleteState(isLoading: true);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String? error;

    try {
      final batch = firestore.batch();

      for (final noteId in noteIds) {
        final noteRef = firestore
            .collection('users')
            .doc(uid)
            .collection('notes')
            .doc(noteId);
        batch.delete(noteRef);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      error = 'Failed to delete notes : ${e.message}';
    }
    state = DeleteState(isLoading: false, errorMessage: error);
  }
}

final deleteNoteProvider =
    NotifierProvider<DeleteNoteNotifier, DeleteState>(DeleteNoteNotifier.new);
