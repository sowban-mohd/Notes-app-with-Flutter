import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/firebase_collections.dart';
import 'package:notetakingapp1/core/providers/firebase_providers.dart';
import 'package:notetakingapp1/features/notes/models/folder.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';
import 'package:notetakingapp1/core/constants/map_keys.dart';

final foldersRepositoryProvider = Provider((ref) => FoldersRepository(
    firestore: ref.read(firestoreProvider), uid: ref.read(uidProvider)));

class FoldersRepository {
  final FirebaseFirestore _firestore;
  final String _uid;
  FoldersRepository({required FirebaseFirestore firestore, required String uid})
      : _firestore = firestore,
        _uid = uid;

  CollectionReference get _folderCollectionRef => _firestore
      .collection(FirebaseCollections.usersCollection.collectionName)
      .doc(_uid)
      .collection(FirebaseCollections.foldersCollection.collectionName);

  CollectionReference get _notesCollectionRef => _firestore
      .collection(FirebaseCollections.usersCollection.collectionName)
      .doc(_uid)
      .collection(FirebaseCollections.notesCollection.collectionName);

  WriteBatch get _batch => _firestore.batch();

  Stream<List<Folder>> getFolders() {
    return _folderCollectionRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .map((folderData) => Folder.fromMap(folderData))
        .toList());
  }

  Future<List<Folder>> getFoldersList() async {
    final snapshots =
        await _folderCollectionRef.orderBy(FolderMapKeys.name.key).get();
    return snapshots.docs
        .map((doc) => Folder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Note>> getFolderNotes(List<dynamic> noteIds) async {
    final futures =
        noteIds.map((noteId) => _notesCollectionRef.doc(noteId).get()).toList();
    final snapshots = await Future.wait(futures);
    return snapshots
        .map(
            (snapshot) => Note.fromMap(snapshot.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> createFolder(Folder folder) async {
    final docRef = _folderCollectionRef.doc();
    await _folderCollectionRef.doc(docRef.id).set({
      ...folder.toMap(),
      FolderMapKeys.id.key: docRef.id,
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> renameFolder(String updatedName, String folderId) async {
    await _folderCollectionRef.doc(folderId).set({
      FolderMapKeys.name.key: updatedName,
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
  }

  Future<void> deleteFolders(List<String> folderIds) async {
    final batch = _batch;
    for (final id in folderIds) {
      final docRef = _folderCollectionRef.doc(id);
      final folderSnapshot = await docRef.get();
      final folderMap = folderSnapshot.data() as Map<String, dynamic>;
      for (var noteId in folderMap[FolderMapKeys.notes.key]) {
        final noteRef = _notesCollectionRef.doc(noteId);
        batch.update(noteRef, {
          NoteMapKeys.folderRefs.key:
              FieldValue.arrayRemove([folderMap[FolderMapKeys.id.key]])
        });
      }
      batch.delete(docRef);
    }
    await batch.commit();
  }

  Future<void> addToFolders(List<String> notes, List<Folder> folders) async {
    final batch = _batch;
    for (Folder folder in folders) {
      for (String note in notes) {
        final noteRef = _notesCollectionRef.doc(note);
        batch.update(noteRef, {
          NoteMapKeys.folderRefs.key: FieldValue.arrayUnion([folder.id])
        });
        if (!folder.noteRefs.contains(note)) {
          folder.noteRefs.add(note);
        }
      }
      final folderRef = _folderCollectionRef.doc(folder.id);
      batch.update(folderRef, {FolderMapKeys.notes.key: folder.noteRefs});
    }
    await batch.commit();
  }

  Future<void> addInFolder(Note note, String folderId) async {
    final batch = _batch;
    final noteRef = _notesCollectionRef.doc();
    batch.set(noteRef, {
      ...note.toMap(),
      NoteMapKeys.folderRefs.key: FieldValue.arrayUnion([folderId]),
      NoteMapKeys.id.key: noteRef.id,
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp()
    });
    final folderRef = _folderCollectionRef.doc(folderId);
    batch.set(
        folderRef,
        {
          FolderMapKeys.notes.key: FieldValue.arrayUnion([noteRef.id]),
          GeneralKeys.timestamp.key: FieldValue.serverTimestamp()
        },
        SetOptions(merge: true));
    await batch.commit();
  }

  Future<void> removeFromFolder(List<dynamic> notes, Folder folder) async {
    final batch = _batch;
    for (var note in notes) {
      final noteRef = _notesCollectionRef.doc(note);
      batch.update(noteRef, {
        NoteMapKeys.folderRefs.key: FieldValue.arrayRemove([note])
      });
    }
    final folderRef = _folderCollectionRef.doc(folder.id);
    batch.update(folderRef, {
      FolderMapKeys.notes.key: FieldValue.arrayRemove(notes),
      GeneralKeys.timestamp.key: FieldValue.serverTimestamp()
    });
    await batch.commit();
  }
}
