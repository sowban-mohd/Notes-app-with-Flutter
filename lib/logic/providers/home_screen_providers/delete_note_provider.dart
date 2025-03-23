import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

/// Notifier that manages deletion state and expose error message if any
class DeleteNoteNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final FirestoreService _firestoreService = FirestoreService();

  /// Deletes selected notes
  Future<void> deleteNote(Set<String> noteIds) async {
    try {
      await _firestoreService.deleteFromCollection(noteIds);
    }
    //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to delete notes : ${e.toString()}';
    }
  }

  void clearError() {
    state = null;
  }
}

/// Provider of DeleteNoteNotifier
final deleteNoteProvider =
    NotifierProvider<DeleteNoteNotifier, String?>(DeleteNoteNotifier.new);
