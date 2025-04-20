import 'package:flutter_riverpod/flutter_riverpod.dart';

//Notifier of selected folder notes
class FolderNoteSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  /// Selects or deselects note
  void toggleSelection(String noteId) {
    if (state.contains(noteId)) {
      state = {...state}..remove(noteId); //Deselects
    } else {
      state = {...state, noteId}; //Selects
    }
  }

  /// Clears selection
  void clearSelection() {
    state = {};
  }
}

/// Provider of SelectionNotifier
final folderNoteSelectionProvider =
    NotifierProvider<FolderNoteSelectionNotifier, Set<String>>(
        FolderNoteSelectionNotifier.new);
