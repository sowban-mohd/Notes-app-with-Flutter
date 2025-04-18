import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

class NoteOpsStateNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final FirestoreService _firestoreService = FirestoreService();

  ///Adds note
  Future<void> addNote(
      {required String title, required String content, String? folder}) async {
    final collection =
        folder != null ? folder.replaceAll(' ', '').toLowerCase() : 'notes';

    //Handles state if title and content field is empty
    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      final note = {'title': title, 'content': content, 'pinned': false};
      final newNoteId = await _firestoreService.addToCollection(
          collection: collection, content: note);
      await _firestoreService.updateInCollection(
          collection: collection,
          docId: newNoteId,
          content: {
            'noteId': newNoteId,
            'timestamp': FieldValue.serverTimestamp()
          });
    } //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to add note : ${e.toString()}';
    }
  }

  /// Updates note
  Future<void> updateNote(
      {required String title,
      required String content,
      required String noteId,
      bool? pinned,
      String? folder}) async {
    final collection =
        folder != null ? folder.replaceAll(' ', '').toLowerCase() : 'notes';
    //Handles state if title and content field is empty
    if (title.isEmpty && content.isEmpty) {
      state = 'Empty note discarded';
      return;
    }

    try {
      final Map<String, dynamic> note = {
        'title': title,
        'content': content,
        'pinned': pinned,
        'timestamp': FieldValue.serverTimestamp()
      };

      await _firestoreService.updateInCollection(
          collection: collection, docId: noteId, content: note);
    }
    //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to update note : ${e.toString()}';
    }
  }

  /// Deletes selected notes
  Future<void> deleteNote({required Set<String> noteIds, String? folder}) async {
     final collection =
        folder != null ? folder.replaceAll(' ', '').toLowerCase() : 'notes';
    try {
      await _firestoreService.deleteFromCollection(
          collection: collection, docIds: noteIds);
    }
    //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to delete notes : ${e.toString()}';
    }
  }

  /// Pin note
  Future<void> pinNote(Set<String> noteIds) async {
    for (var noteId in noteIds) {
      final updatedNote = {
        'pinned': true,
      };
      await _firestoreService.updateInCollection(
          collection: 'notes', docId: noteId, content: updatedNote);
    }
  }

  /// Unpin note
  Future<void> unPinNote(Set<String> notes) async {
    for (var noteId in notes) {
      final updatedNote = {
        'pinned': false,
      };
      await _firestoreService.updateInCollection(
          collection: 'notes', docId: noteId, content: updatedNote);
    }
  }
}

///Provider of Note Ops Notifier
final noteOpsStateProvider =
    NotifierProvider<NoteOpsStateNotifier, String?>(NoteOpsStateNotifier.new);
