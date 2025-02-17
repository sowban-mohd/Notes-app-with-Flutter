import 'package:flutter_riverpod/flutter_riverpod.dart';

//Notifier of selected notes
class SelectionNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  //Selects or deselects note based on it's Id
  void toggleSelection(String noteId) {
    //Deselects
    if (state[noteId] == true) {
      final newState = Map<String, bool>.from(state);
      newState.remove(noteId);
      state = newState;
    }
    //Selects
    else {
      state = {...state, noteId: true};
    }
  }

  /// Clears selection
  void clearSelection() {
    state = {};
  }

  ///List of selected noteIds
  List<String> get selectedNotes => state.keys.toList();
}

/// Provider of SelectionNotifier
final selectionProvider =
    NotifierProvider<SelectionNotifier, Map<String, bool>>(
        SelectionNotifier.new);
