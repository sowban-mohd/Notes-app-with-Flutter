import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveNoteState {
  final bool isLoading;
  final String? error;
  final String? success;

  SaveNoteState({required this.isLoading, this.error, this.success});
}

class SaveNoteNotifier extends Notifier<SaveNoteState> {
  @override
  SaveNoteState build() => SaveNoteState(isLoading: false);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   
   void clearState() {
    state = SaveNoteState(isLoading: false);
  }
  Future<void> saveNote(String title, String content, {String? noteId}) async {
    state = SaveNoteState(isLoading: true);
    String? error;
    String? success;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (title.isEmpty && content.isEmpty) {
      state = SaveNoteState(
          isLoading: false,
          error: 'Hold up, wait a minute, something ain\'t right');
      return;
    }
    try {
      final noteRef =
          _firestore.collection('users').doc(uid).collection('notes');

      if (noteId != null) {
        await noteRef.doc(noteId).update({
          'title': title,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });
        success = 'Note updated successfully';
      } else {
        final docRef = await noteRef.add({
          'title': title,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await docRef.update({'noteId': docRef.id});
        success = 'Note added succesfully';
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        error = 'No internet connection, try again';
      } else {
        error = 'Failed to save note : $e';
      }
    }
    state = SaveNoteState(isLoading: false, error: error, success: success);
  }
}

final saveNoteProvider =
    NotifierProvider<SaveNoteNotifier, SaveNoteState>(SaveNoteNotifier.new);
