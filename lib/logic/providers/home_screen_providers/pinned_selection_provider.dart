import 'package:flutter_riverpod/flutter_riverpod.dart';

//Notifier of selected notes
class PinnedSelectionNotifier extends Notifier<Set<String>> {
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
final pinnedSelectionProvider =
    NotifierProvider<PinnedSelectionNotifier, Set<String>>(PinnedSelectionNotifier.new);
