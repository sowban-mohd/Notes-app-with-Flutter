import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class NotesController extends GetxController {
  final notesBox = Hive.box('notes');
  var notes = <Map<String, dynamic>>[].obs;
  var selectedNotes = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    notes.value = notesBox.values.cast<Map<String, dynamic>>().toList();
  }

  void saveNote({int? index, String? title, String? content}) {
    index != null ?
    //If index already exists, update the note in that index with the given content
    notesBox.putAt(index, {
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString()
    }) :
    //If index doesn't exist, add the new note to the box
    notesBox.add({
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString()
    });
    loadNotes();
  }

  void deleteNote(int index) {
    notesBox.deleteAt(index);
    loadNotes();
  }

  void selectNote(int index) {
    selectedNotes.add(index);
  }
}
