import 'package:get/get.dart';
import 'package:notetakingapp1/logic/services/hive_service.dart';

class NotesController extends GetxController {
  final _hiveService = HiveService();
  var pinnedNotes = <Map<dynamic, dynamic>>[].obs;
  var otherNotes = <Map<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    loadPinnedNotes();
    loadOtherNotes();
  }

  void loadPinnedNotes() {
    pinnedNotes.assignAll(_hiveService.getPinnedNotes());
  }

  void loadOtherNotes() {
    otherNotes.assignAll(_hiveService.getOtherNotes());
  }

  Future<void> saveNote(
      {int? key,
      required String title,
      required String content,
      bool? isPinned}) async {
    if (key != null && isPinned != null) {
      if (isPinned) {
        await _hiveService.putInPinnedNotes(
            key: key, title: title, content: content);
        loadPinnedNotes();
      } else {
        await _hiveService.putInOtherNotes(
            key: key, title: title, content: content);
        print('update is run');
        loadOtherNotes();
      }
    } else {
      int notekey =
          await _hiveService.addInOtherNotes(title: title, content: content);
      await _hiveService.putInOtherNotes(
          key: notekey, title: title, content: content);
      print('add is run');
      loadOtherNotes();
    }
  }

  Future<void> deleteNote(Set<int> selectedNotes) async {
    await _hiveService.deleteFromPinnedNotes(selectedNotes);
    await _hiveService.deleteFromOtherNotes(selectedNotes);
    loadNotes();
  }

  Future<void> pinNote(Set<int> keys) async {
    for (var key in keys) {
      var note = _hiveService.fetchfromOtherNotes(key);
      var title = note['title'];
      var content = note['content'];
      await _hiveService.putInPinnedNotes(
          key: key, title: title, content: content);
    }
    await _hiveService.deleteFromOtherNotes(keys);
    loadNotes();
  }

  Future<void> unPinNote(Set<int> keys) async {
    for (var key in keys) {
      var note = _hiveService.fetchfromPinnedNotes(key);
      if (note != null) {
        var title = note['title'];
        var content = note['content'];
        await _hiveService.putInOtherNotes(
            key: key, title: title, content: content);
      }
    }
    await _hiveService.deleteFromPinnedNotes(keys);
    loadNotes();
  }
}
