import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void toggleSelection(String noteId) {
    if (state[noteId] == true) {
      final newState = Map<String, bool>.from(state);
      newState.remove(noteId);
      state = newState;
    } else {
      state = {...state, noteId: true};
    }
  }

  void clearSelection() {
    state = {};
  }

  bool get isSelectionActive => state.isNotEmpty;

  List<String> get selectedNotes => state.keys.toList();
}

final selectionProvider =
    NotifierProvider<SelectionNotifier, Map<String, bool>>(
        SelectionNotifier.new);
