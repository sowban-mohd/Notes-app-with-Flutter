import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

///Notifier that manage and expose note saving state
class SaveNoteNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final FirestoreService _firestoreService = FirestoreService();

  /// Saves or updates note
  Future<void> saveNote(String title, String content, {String? noteId}) async {
    //Handles state if title and content field is empty
    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      //Checks if the process is updation/creation and performs operation accordingly
      if (noteId != null) {
        await _firestoreService.updateNote(title, content, noteId: noteId);
      } else {
        await _firestoreService.addNote(title, content);
      }
    }

    //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to save note : ${e.toString()}';
    }
  }

  void clearError() {
    state = null;
  }
}

///Provider of Save Note Notifier
final saveNoteProvider =
    NotifierProvider<SaveNoteNotifier, String?>(SaveNoteNotifier.new);
