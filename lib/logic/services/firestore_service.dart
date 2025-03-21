import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;
  CollectionReference<Map<String, dynamic>> get _noteRef {
    return _firestore.collection('users').doc(_uid).collection('notes');
  }

  /// Returns a stream of notes
  Stream getNotesStream() {
    if (_uid == null) {
      return Stream.empty();
    } // Return an empty stream when the user is logged out to prevent Firestore errors

    return _noteRef
        .orderBy('timestamp',
            descending: true) //Sorts based on created/updated time
        .snapshots() //Real-time updates
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    //Converts each note to a map and all the notes to list of maps
  }
  
  ///Adds note to the collection with the given title, content
  Future<void> addNote(String title, String content) async {
    final docRef = await _noteRef.add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    //Updates the document with related noteId after creation
    await docRef.update({'noteId': docRef.id});
  }

  /// Updates the note of given noteId with the given title, content
  Future<void> updateNote(String title, String content, {String? noteId}) async {
    //Updates note
    await _noteRef.doc(noteId).update({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes note from the collection with specific noteIds
  Future<void> deleteNote(Set<String> noteIds) async {
    //Enables firebase batch opeartions
      final batch = _firestore.batch();

      for (final noteId in noteIds) {
        final noteRef = _firestore
            .collection('users')
            .doc(_uid)
            .collection('notes')
            .doc(noteId);

        //Queues delete operation for each notes with noteIds from the list inside user's notes collection
        batch.delete(noteRef);
      }
      //Performs queued batch operations
      await batch.commit();
  }
}
