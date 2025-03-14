import 'package:get/get.dart';

class SelectedNotesController extends GetxController {
  var selectedNotes = <int>{}.obs;

  ///Selects or deselects note with specific key
  void toggleSelection(int key) {
    selectedNotes.contains(key)
        ? selectedNotes.remove(key) //Deselects notes with specific index
        : selectedNotes.add(key); //Selects notes with specific index
  }

  bool isSelected(int key) => selectedNotes.contains(key);
}
