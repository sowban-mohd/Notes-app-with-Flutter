import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';

final selectedNotesControllerProvider =
    NotifierProvider.family<SelectedNotesController, List<String>, NoteType>(
  SelectedNotesController.new,
);

// Controller of selected notes
class SelectedNotesController extends FamilyNotifier<List<String>, NoteType> {
  @override
  List<String> build(NoteType type) => <String>[];

  /// Selects or deselects note's id
  void toggleSelection(String noteId) {
    if (state.contains(noteId)) {
      state = [...state]..remove(noteId); // Deselect
    } else {
      state = [...state, noteId]; // Select
    }
  }

  /// Clears selection
  void clearSelection() {
    state = [];
  }
}
