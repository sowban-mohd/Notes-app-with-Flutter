import 'package:get/get.dart';

class SelectedNotesController extends GetxController {
  var selectedPinnedNotes = <int>{}.obs;
  var selectedNotes = <int>{}.obs;

  ///Selects or deselects note with specific key
  void toggleSelection({required int key, required bool isPinned}) {
    if (isPinned) {
      selectedNotes.contains(key)
          ? selectedNotes.remove(key)
          : selectedNotes.add(key);
      selectedPinnedNotes.contains(key)
          ? selectedPinnedNotes.remove(key)
          : selectedPinnedNotes.add(key);
    } else {
      selectedNotes.contains(key)
          ? selectedNotes.remove(key)
          : selectedNotes.add(key);
    }
  }

  bool isSelected(int key) {
    return selectedNotes.contains(key);
  }
}
