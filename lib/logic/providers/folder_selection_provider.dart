import 'package:flutter_riverpod/flutter_riverpod.dart';

//Notifier of selected folders
class FolderSelectionNotifier extends Notifier<Set<Map<String, dynamic>>> {
  @override
  Set<Map<String, dynamic>> build() => {};

  /// Selects or deselects folder
  void toggleSelection(Map<String, dynamic> folder) {
    if (state.contains(folder)) {
      state = {...state}..remove(folder); //Deselects
    } else {
      state = {...state, folder}; //Selects
    }
  }

  /// Clears selection
  void clearSelection() {
    state = {};
  }
}

/// Provider of SelectionNotifier
final folderSelectionProvider =
    NotifierProvider<FolderSelectionNotifier, Set<Map<String, dynamic>>>(FolderSelectionNotifier.new);
