import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

class NoteCudStateNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final FirestoreService _firestoreService = FirestoreService();

  /// Saves or updates note
  Future<void> saveNote(
      {required String title,
      required String content,
      String? noteId,
      bool? pinned}) async {
    //Handles state if title and content field is empty
    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      //Checks if the process is updation/creation and performs operation accordingly
      if (noteId != null) {
        await _firestoreService.updateInCollection(
            title: title, content: content, noteId: noteId, pinned: pinned!);
      } else {
        var newNoteId = await _firestoreService.addToCollection(title, content);
        await _firestoreService.updateInCollection(
            title: title, content: content, noteId: newNoteId, pinned: false);
      }
    }

    //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to save note : ${e.toString()}';
    }
  }

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

  /// Pin note
  Future<void> pinNote(Set<String> noteIds) async {
    for (var noteId in noteIds) {
      final notes = ref.read(notesProvider);
      final note = notes.firstWhere((note) => note['noteId'] == noteId);
      final title = note['title'];
      final content = note['content'];
      await _firestoreService.updateInCollection(
          noteId: noteId, title: title, content: content, pinned: true);
    }
  }

  /// Unpin note
  Future<void> unpinNote(Set<String> noteIds) async {
    for (var noteId in noteIds) {
      final notes = ref.read(notesProvider);
      final note = notes.firstWhere((note) => note['noteId'] == noteId);
      final title = note['title'];
      final content = note['content'];
      await _firestoreService.updateInCollection(
          noteId: noteId, title: title, content: content, pinned: false);
    }
  }

  void clearError() {
    state = null;
  }
}

///Provider of Save Note Notifier
final noteCudProvider =
    NotifierProvider<NoteCudStateNotifier, String?>(NoteCudStateNotifier.new);
