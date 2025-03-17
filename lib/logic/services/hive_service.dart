import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final notesBox = Hive.box('notes');

  /// Retrieves all notes
  List<Map<dynamic, dynamic>> getNotes() {
    return notesBox.values.cast<Map<dynamic, dynamic>>().toList();
  }

  /// Adds the note with given title and content
  Future<void> addNote({required String title, required String content}) async {
    // Add a new note and retrieve its key
    int key = await notesBox.add({
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString(),
    });

    updateNote(key: key, title: title, content: content); //Update the note with it's key right away
  }

  Future<void> updateNote({int? key, String? title, String? content}) async {
    await notesBox.put(key, {
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString(),
      'key': key,
    });
  }

  Future<void> deleteNote(List<int> selectedNotes) async {
     await notesBox.deleteAll(selectedNotes);
  }
}
