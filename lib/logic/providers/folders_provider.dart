import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

class FoldersNotifier extends Notifier<List<Map<String, dynamic>>> {
  final FirestoreService _firestoreService = FirestoreService();
  late bool isLoading;
  String? errorMessage;

  @override
  List<Map<String, dynamic>> build() {
    _listenToFolders();
    return [];
  }

  void _listenToFolders() {
    isLoading = true;
    _firestoreService.getCollectionStream('folders').listen((folders) {
      state = folders;
      isLoading = false;
    }, onError: (e) {
      isLoading = false;
      errorMessage = e.toString();
      debugPrint('Error fetching folders: $errorMessage');
    });
  }

  void retry() {
    _listenToFolders();
  }

  void clearError() {
    errorMessage = null;
  }
}

final foldersProvider =
    NotifierProvider<FoldersNotifier, List<Map<String, dynamic>>>(
        FoldersNotifier.new);
