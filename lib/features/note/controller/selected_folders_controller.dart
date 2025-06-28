import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFoldersControllerProvider =
    NotifierProvider<SelectedFoldersController, List<String>>(
  SelectedFoldersController.new,
);

// Controller for selected folders
class SelectedFoldersController extends Notifier<List<String>> {
  @override
  List<String> build() => <String>[];

  /// Selects or deselects a folder
  void toggleSelection(String folderId) {
    if (state.contains(folderId)) {
      state = [...state]..remove(folderId); // Deselect
    } else {
      state = [...state, folderId]; // Select
    }
  }

  /// Clears all selections
  void clearSelection() {
    state = [];
  }
}
