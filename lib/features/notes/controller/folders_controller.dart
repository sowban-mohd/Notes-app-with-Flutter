import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/models/folder.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';
import 'package:notetakingapp1/features/notes/models/ops_state.dart';
import 'package:notetakingapp1/features/notes/repository/folders_repository.dart';

final foldersControllerProvider =
    NotifierProvider<FoldersController, OpsState>(FoldersController.new);

final folderStreamProvider =
    StreamProvider((ref) => ref.read(foldersRepositoryProvider).getFolders());

final folderNotesProvider = FutureProviderFamily(
    (ref, List<dynamic> folderNoteRefs) =>
        ref.read(foldersRepositoryProvider).getFolderNotes(folderNoteRefs));

final foldersListProvider =
    StateProvider<List<Folder>>((ref) => []);

final currentlyClickedFolderProvider = StateProvider<String?>((ref) => null);

class FoldersController extends Notifier<OpsState> {
  late final FoldersRepository _foldersRepository;

  @override
  OpsState build() {
    _foldersRepository = ref.read(foldersRepositoryProvider);
    return  OpsState();
  }

  Future<void> createFolder(String name) async {
    final foldername = name.isEmpty ? 'Unnamed folder' : name;
    final folder = Folder(name: foldername, noteRefs: <String>[]);
    try {
      await _foldersRepository.createFolder(folder);
      state = OpsState(successMessage: 'Folder added successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to create folder: $e');
    }
  }

  Future<List<Note>> getFolderNotes(List<dynamic> noteIds) {
    return _foldersRepository.getFolderNotes(noteIds);
  }

  Future<List<Folder>> getFoldersList() {
    return _foldersRepository.getFoldersList();
  }

  Future<void> renameFolder({
    required String updatedName,
    required String folderId,
  }) async {
    final folderName = updatedName.isEmpty ? 'Unnamed folder' : updatedName;
    try {
      await _foldersRepository.renameFolder(folderName, folderId);
      state = OpsState(successMessage: 'Folder renamed successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to rename folder: $e');
    }
  }

  Future<void> deleteFolder(List<String> folderIds) async {
    try {
      await _foldersRepository.deleteFolders(folderIds);
      state = OpsState(successMessage: 'Folder(s) deleted successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to delete folder(s): $e');
    }
  }

  Future<void> addToFolders({
    required List<String> notesToBeAdded,
    required List<Folder> foldersToAdd,
  }) async {
    try {
      await _foldersRepository.addToFolders(notesToBeAdded, foldersToAdd);
      state = OpsState(successMessage: 'Notes added to folders successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to add notes to folders: $e');
    }
  }

  Future<void> addInFolder(String title, String content, String folderId) async {
    if (title.isEmpty && content.isEmpty) {
      state = OpsState(errorMessage: 'Empty note discarded');
      return;
    }
    final note = Note(title: title, content: content, pinned: false, folderRefs: []);
    try {
      await _foldersRepository.addInFolder(note, folderId);
      state = OpsState(successMessage: 'Note added to folder successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to add note to folder: $e');
    }
  }

  Future<void> removeFromFolder({
    required List<dynamic> noteIds,
    required Folder folder,
  }) async {
    try {
      await _foldersRepository.removeFromFolder(noteIds, folder);
      state = OpsState(successMessage: 'Note(s) removed from folder successfully');
    } catch (e) {
      state = OpsState(errorMessage: 'Failed to remove notes from folder: $e');
    }
  }
}
