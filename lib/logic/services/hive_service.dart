import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final pinnedNotesBox = Hive.box('PinnedNotes');
  final otherNotesBox = Hive.box('OtherNotes');

  /// Retrives pinned notes
  List<Map<dynamic, dynamic>> getPinnedNotes() {
    return pinnedNotesBox.values.cast<Map<dynamic, dynamic>>().toList();
  }

  /// Retrieves other notes
  List<Map<dynamic, dynamic>> getOtherNotes() {
    return otherNotesBox.values.cast<Map<dynamic, dynamic>>().toList();
  }

  /// Adds the note with given title and content to 'OtherNotes' box and retrives it's key
  Future<int> addInOtherNotes(
      {required String title, required String content}) async {
    return await otherNotesBox.add({
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString(),
    });
  }

  /// Puts the note in given key with given title and content in 'OtherNotes' box
  Future<void> putInOtherNotes(
      {required int key, String? title, String? content}) async {
    await otherNotesBox.put(key, {
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString(),
      'key': key,
    });
  }

  ///Fetches note with the given key from 'OtherNotes' box
  Map<dynamic, dynamic> fetchfromOtherNotes(int key) {
    return otherNotesBox.get(key);
  }

  /// Deletes the notes of given keys from 'OtherNotes' box
  Future<void> deleteFromOtherNotes(Set<int> selectedNotes) async {
    await otherNotesBox.deleteAll(selectedNotes);
  }

  /// Puts the note in given key with given title and content in 'PinnedNotes' box
  Future<void> putInPinnedNotes(
      {required int key, String? title, String? content}) async {
    await pinnedNotesBox.put(key, {
      'title': title,
      'content': content,
      'timeStamp': DateTime.now().toString(),
      'key': key,
    });
  }

  ///Fetches note with the given key from 'PinnedNotes' box
  Map<dynamic, dynamic>? fetchfromPinnedNotes(int key) {
    return pinnedNotesBox.get(key);
  }

  /// Deletes the notes of given keys from 'PinnedNotes' box
  Future<void> deleteFromPinnedNotes(Set<int> selectedNotes) async {
    await pinnedNotesBox.deleteAll(selectedNotes);
  }
}
