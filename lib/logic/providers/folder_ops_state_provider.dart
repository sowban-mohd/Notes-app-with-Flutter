import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

class FolderOpsStateNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  final _firestoreService = FirestoreService();

  Future<void> addFolder(String folderName) async {
    try {
      Map<String, dynamic> content = {
        'name': folderName,
      };
      final folderId = await _firestoreService.addToCollection(
          collection: 'folders', content: content);
      await _firestoreService.updateInCollection(
          collection: 'folders',
          docId: folderId,
          content: {
            ...content,
            'folderId': folderId,
            'timestamp': FieldValue.serverTimestamp()
          });
    } //Handles Firebase errors
    on FirebaseException catch (e) {
      state = 'Failed to add folder : ${e.toString()}';
    }
  }

  Future<void> updateFolder(String folderId, String folderName) async {
    try {
      Map<String, dynamic> content = {
        'name': folderName,
        'timeStamp': FieldValue.serverTimestamp(),
      };
      await _firestoreService.updateInCollection(
          collection: 'folders', docId: folderId, content: content);
    } on FirebaseException catch (e) {
      state = 'Failed to update folder : ${e.toString()}';
    }
  }

 Future<void> deleteFolders(Set<Map<String, dynamic>> folders) async {
  try {
    final folderIds = folders.map((folder) => folder['folderId'] as String).toSet();

    await _firestoreService.deleteFromCollection(
      collection: 'folders',
      docIds: folderIds,
    );
  } on FirebaseException catch (e) {
    state = 'Failed to delete folder: ${e.toString()}';
  }
}

}

final folderOpsStateProvider =
    NotifierProvider<FolderOpsStateNotifier, String?>(
        FolderOpsStateNotifier.new);
