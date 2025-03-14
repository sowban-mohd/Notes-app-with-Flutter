import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class NotesController extends GetxController {
  final notesBox = Hive.box('notes');
  var notes = <Map<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }
  
  /// Assigns all notes from the hive notes box to the notes list
  void loadNotes() {
    notes.assignAll(notesBox.values.cast<Map<dynamic, dynamic>>().toList());
  }

  Future<void> saveNote({int? key, String? title, String? content}) async {
    if (key != null) {
      // If a key is provided, update the existing note
      await notesBox.put(key, {
        'title': title,
        'content': content,
        'timeStamp': DateTime.now().toString(),
        'key': key,
      });
      loadNotes(); //Refresh notes list
    } else {
      // Add a new note and retrieve its key
      int noteKey = await notesBox.add({
        'title': title,
        'content': content,
        'timeStamp': DateTime.now().toString(),
      });

      await notesBox.put(noteKey, {
        'title': title,
        'content': content,
        'timeStamp': DateTime.now().toString(),
        'key': noteKey,
      }); //Update the note with it's key right away

      //Refresh notes list after adding
      var note = notesBox.get(noteKey);
      notes.add(note as Map<String, dynamic>);
    }
  }

  Future<void> deleteNote(List<int> selectedNotes) async {
    await notesBox.deleteAll(selectedNotes);
    loadNotes(); //Refresh notes list
  }
}
