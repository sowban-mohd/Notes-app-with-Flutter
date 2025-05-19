import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetakingapp1/logic/providers/firebase_providers.dart';

class FolderOpsStateNotifier extends Notifier<String?> {
  FirebaseAuth get _auth => ref.read(authProvider);
  FirebaseFirestore get _firestore => ref.read(firestoreProvider);
  String? get _uid => _auth.currentUser?.uid;

  @override
  String? build() {
    return null;
  }

  Future<void> addFolder(String folderName) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('folders');

    try {
      final content = {'name': folderName};
      final docRef = await collectionRef.add(content);
      await collectionRef.doc(docRef.id).set({
        'folderId': docRef.id,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Failed to add folder : ${e.toString()}';
    }
  }

  Future<void> updateFolder(String folderId, String folderName) async {
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('folders');

    try {
      final content = {
        'name': folderName,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await collectionRef.doc(folderId).set(content, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      state = 'Failed to update folder : ${e.toString()}';
    }
  }

  Future<void> deleteFolders(Set<Map<String, dynamic>> folders) async {
    final batch = _firestore.batch();
    final collectionRef =
        _firestore.collection('users').doc(_uid).collection('folders');

    try {
      final folderIds = folders.map((folder) => folder['folderId'] as String);
      for (final id in folderIds) {
        final docRef = collectionRef.doc(id);
        batch.delete(docRef);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      state = 'Failed to delete folder: ${e.toString()}';
    }
  }
}

final folderOpsStateProvider =
    NotifierProvider<FolderOpsStateNotifier, String?>(
        FolderOpsStateNotifier.new);
