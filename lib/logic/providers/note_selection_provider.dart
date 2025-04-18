import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NoteType {
  pinned,
  all,
}

//Notifier of selected notes
class NoteSelectionNotifier extends FamilyNotifier<Set<String>, NoteType> {
  @override
  Set<String> build(NoteType type) => {};

  /// Selects or deselects note's id
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
final noteSelectionProvider =
    NotifierProvider.family<NoteSelectionNotifier, Set<String>, NoteType>(
  NoteSelectionNotifier.new,
);