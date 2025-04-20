import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_selection_provider.dart';

class ShouldSelectAllNotesNotifier extends Notifier<bool> {
  @override
  bool build() {
    ref.listen(noteSelectionProvider(NoteType.all), (prev, next) {
      if (next.isEmpty) state = false;
    });
    return false;
  }
 void toggleSelection(){
  state = !state;
 }
 
  void selectAll() {
    state = true;
  }

  void unSelectAll() {
    state = false;
  }
}

final shouldSelectAllNotesProvider =
    NotifierProvider<ShouldSelectAllNotesNotifier, bool>(
        ShouldSelectAllNotesNotifier.new);
