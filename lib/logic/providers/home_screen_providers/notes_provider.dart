import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/services/firestore_service.dart';

class NotesNotifier extends Notifier<List<Map<String, dynamic>>> {
  final FirestoreService _firestoreService = FirestoreService();
  late bool isLoading;
  String? errorMessage;

  @override
  List<Map<String, dynamic>> build() {
    _listenToNotes();
    return [];
  }

  void _listenToNotes() {
    isLoading = true;
    _firestoreService.getNotesStream().listen((notes) {
      state = notes;
      isLoading = false;
    }, onError: (e) {
      isLoading = false;
      errorMessage = e.toString();
      debugPrint('Error fetching notes: $errorMessage');
    });
  }

  void retry() {
    _listenToNotes();
  }

  void clearError() {
    errorMessage = null;
  }
}

final notesProvider =
    NotifierProvider<NotesNotifier, List<Map<String, dynamic>>>(
        NotesNotifier.new);
