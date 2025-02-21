import 'package:flutter_riverpod/flutter_riverpod.dart';

//Notifier of selected notes
class SelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  /// Selects or deselects note based on it's Id
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
final selectionProvider =
    NotifierProvider<SelectionNotifier, Set<String>>(SelectionNotifier.new);
