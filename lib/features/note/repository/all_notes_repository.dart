import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/firebase_collections.dart';
import 'package:notetakingapp1/core/constants/map_keys.dart';
import 'package:notetakingapp1/core/providers/firebase_providers.dart';
import 'package:notetakingapp1/features/note/models/note.dart';

final allNotesRepositoryProvider = Provider((ref) => AllNotesRepository(
    firestore: ref.read(firestoreProvider), uid: ref.read(uidProvider)));

class AllNotesRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  AllNotesRepository({
    required FirebaseFirestore firestore,
    required String uid,
  })  : _firestore = firestore,
        _uid = uid;

  CollectionReference get _notesCollectionRef => _firestore
      .collection(FirebaseCollections.usersCollection.collectionName)
      .doc(_uid)
      .collection(FirebaseCollections.notesCollection.collectionName);

  CollectionReference get _folderCollectionRef => _firestore
      .collection(FirebaseCollections.usersCollection.collectionName)
      .doc(_uid)
      .collection(FirebaseCollections.foldersCollection.collectionName);

  WriteBatch get _batch => _firestore.batch();

  Stream<List<Note>> getNotes() {
    return _notesCollectionRef
        .orderBy(GeneralKeys.timestamp.key, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .map((notedata) => Note.fromMap(notedata))
            .toList());
  }

  Future<void> addNote(Note note) async {
    final docRef = _notesCollectionRef.doc();
    await docRef.set({
      ...note.toMap(),
      NoteMapKeys.id.key: docRef.id,
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(Note note) async {
    await _notesCollectionRef.doc(note.id).set({
      ...note.toMap(),
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote({required List<dynamic> noteIds}) async {
    final batch = _batch;
    for (final noteId in noteIds) {
      final docRef = _notesCollectionRef.doc(noteId);
      final noteSnapshot = await docRef.get();
      final note = noteSnapshot.data() as Map<String, dynamic>;
      for (var folderId in note[NoteMapKeys.folderRefs.key]) {
        final folderRef = _folderCollectionRef.doc(folderId);
        batch.update(folderRef, {
          FolderMapKeys.notes.key: FieldValue.arrayRemove([note['id']])
        });
      }
      batch.delete(docRef);
    }
    await batch.commit();
  }

  Future<void> copyNote(List<dynamic> notesToCopy) async {
    final batch = _batch;
    for (var noteToCopy in notesToCopy) {
      final ogNoteDataSnapshot = await _notesCollectionRef.doc(noteToCopy).get();
      final ogNote =
          Note.fromMap(ogNoteDataSnapshot.data() as Map<String, dynamic>);
      final docRef = _notesCollectionRef.doc();
      final copiedNote = ogNote.copyWith(pinned: false, id: docRef.id);
      batch.set(docRef, {
        ...copiedNote.toMap(),
        GeneralKeys.timestamp.key: FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> pinNote(List<dynamic> noteIds) async {
    final batch = _batch;
    for (var noteId in noteIds) {
      final docRef = _notesCollectionRef.doc(noteId);
      final updatedNote = {NoteMapKeys.pinned.key: true};
      batch.set(docRef, updatedNote, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<void> unPinNote(List<String> noteIds) async {
    final batch = _batch;
    for (var noteId in noteIds) {
      final docRef = _notesCollectionRef.doc(noteId);
      final updatedNote = {NoteMapKeys.pinned.key: false};
      batch.set(docRef, updatedNote, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
