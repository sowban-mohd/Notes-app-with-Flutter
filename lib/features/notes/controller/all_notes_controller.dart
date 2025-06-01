import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';
import 'package:notetakingapp1/features/notes/models/ops_state.dart';
import 'package:notetakingapp1/features/notes/repository/all_notes_repository.dart';

final allNotesControllerProvider =
    NotifierProvider<AllNotesController, OpsState>(AllNotesController.new);

final allNotesStream =
    StreamProvider((ref) => ref.read(allNotesRepositoryProvider).getNotes());

final allNotesListProvider = StateProvider<List<Note>>((ref) => []);

class AllNotesController extends Notifier<OpsState> {
  late final AllNotesRepository _allNotesRepository;

  @override
  OpsState build() {
    _allNotesRepository = ref.read(allNotesRepositoryProvider);
    return OpsState();
  }

  Future<void> addNote({required String title, required String content}) async {
    if (title.isEmpty && content.isEmpty) {
      state = OpsState(errorMessage: 'Empty note discarded');
      return;
    }

    final note = Note(
      title: title,
      content: content,
      pinned: false,
      folderRefs: [],
    );

    try {
      await _allNotesRepository.addNote(note);
      state = OpsState(successMessage: 'Note added successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to add note: ${e.toString()}');
    }
  }

  Future<void> updateNote(Note updatedNote) async {
    if (updatedNote.title.isEmpty && updatedNote.content.isEmpty) {
      state = OpsState(errorMessage: 'Empty note discarded');
      return;
    }

    try {
      await _allNotesRepository.updateNote(updatedNote);
      state = OpsState(successMessage: 'Note updated successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to update note: ${e.toString()}');
    }
  }

  Future<void> deleteNote(List<String> noteIds) async {
    try {
      await _allNotesRepository.deleteNote(noteIds: noteIds);
      state = OpsState(successMessage: 'Note(s) deleted successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to delete note(s): ${e.toString()}');
    }
  }

  Future<void> copyNote(List<String> noteIds) async {
    try {
      await _allNotesRepository.copyNote(noteIds);
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to copy note(s): ${e.toString()}');
    }
  }

  Future<void> pinNote(List<String> noteIds) async {
    try {
      await _allNotesRepository.pinNote(noteIds);
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to pin note(s): ${e.toString()}');
    }
  }

  Future<void> unPinNote(List<String> noteIds) async {
    try {
      await _allNotesRepository.unPinNote(noteIds);
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to unpin note(s): ${e.toString()}');
    }
  }
}
