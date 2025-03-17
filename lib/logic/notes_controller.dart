import 'package:get/get.dart';
import 'package:notetakingapp1/logic/services/hive_service.dart';

class NotesController extends GetxController {
  final hiveService = HiveService();
  var notes = <Map<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  /// Assigns all notes from the hive notes box to the notes list
  void loadNotes() {
    notes.assignAll(hiveService.getNotes());
  }

  Future<void> saveNote(
      {int? key, required String title, required String content}) async {
    if (key != null) {
     await hiveService.updateNote(key: key, title: title, content: content);
      loadNotes();
    } else {
      await hiveService.addNote(title: title, content: content);
      loadNotes();
    }
  }

  Future<void> deleteNote(List<int> selectedNotes) async {
    await hiveService.deleteNote(selectedNotes);
    loadNotes();
  }
}
