import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveNoteState {
  final bool isLoading;
  final String? error;

  SaveNoteState({required this.isLoading, this.error});
}

class SaveNoteNotifier extends Notifier<SaveNoteState> {
  @override
  SaveNoteState build() => SaveNoteState(isLoading: false);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNote(String title, String content) async {
    state = SaveNoteState(isLoading: true);
    String? error;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (title.isEmpty && content.isEmpty) {
      state = SaveNoteState(
          isLoading: false,
          error: 'Hold up, wait a minute, something ain\'t right');
      return;
    }
    try {
      await _firestore.collection('users').doc(uid).collection('notes').add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        error = 'No internet connection, try again';
      } else {
        error = 'Failed to save note : $e';
      }
    }
    state = SaveNoteState(isLoading: false, error: error);
  }
}

final saveNoteProvider =
    NotifierProvider<SaveNoteNotifier, SaveNoteState>(SaveNoteNotifier.new);
