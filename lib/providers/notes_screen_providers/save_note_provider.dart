import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///Manages the state of note saving
class SaveNoteState {
  final bool isLoading;
  final String? error;
  final String? success;

  SaveNoteState({required this.isLoading, this.error, this.success});
}

///Notifier that manage and expose note saving state 
class SaveNoteNotifier extends Notifier<SaveNoteState> {

  @override
  SaveNoteState build() => SaveNoteState(isLoading: false);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   
   ///Clears the state
   void clearState() {
    state = SaveNoteState(isLoading: false);
  }

  /// Saves or updates note 
  Future<void> saveNote(String title, String content, {String? noteId}) async {
    state = SaveNoteState(isLoading: true);
    String? error;
    String? success;
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    //Handles state if title and content field is empty
    if (title.isEmpty && content.isEmpty) {
      state = SaveNoteState(
          isLoading: false,
          error: 'Can\'t save an empty n0te');
      return;
    }

    try {

      final noteRef =
          _firestore.collection('users').doc(uid).collection('notes');
 
      //Checks if the process is updation/creation and performs operation accordingly
      if (noteId != null) {

        //Updates note
        await noteRef.doc(noteId).update({
          'title': title,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });

        success = 'Note updated successfully';

      } else {

        //Creates note
        final docRef = await noteRef.add({
          'title': title,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });

        //Updates the document with related noteId after creation 
        await docRef.update({'noteId': docRef.id});

        success = 'Note added succesfully';

      }
    } 

    //Handles Firebase errors
    on FirebaseException catch (e) {

      if (e.code == 'unavailable') {
        error = 'No internet connection, try again';
      } else {
        error = 'Failed to save note : $e';
      }

    }

    state = SaveNoteState(isLoading: false, error: error, success: success);

  }
}

///Provider of Save Note Notifier
final saveNoteProvider =
    NotifierProvider<SaveNoteNotifier, SaveNoteState>(SaveNoteNotifier.new);
