import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/features/notes/controller/all_notes_controller.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';
import 'package:notetakingapp1/features/notes/controller/selected_notes_controller.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/add_to_folders_dialog.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/confirmaton_dialog.dart';

enum FolderNoteAction {
  delete,
  addToOtherFolders,
  removeFromFolder,
}

class AppBarWithFolderNotesOps extends ConsumerWidget {
  const AppBarWithFolderNotesOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Selection Controller
    final selectionController = ref
        .read(selectedNotesControllerProvider(NoteType.folderNotes).notifier);

    final notesController = ref.read(allNotesControllerProvider.notifier);
    final foldersController = ref.read(foldersControllerProvider.notifier);

    final currentlyClickedFolder = ref.watch(currentlyClickedFolderProvider);

    //Helper methods
    void clearSelection() => selectionController.clearSelection();

    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      title: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextButton.icon(
          onPressed: () {
            clearSelection();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFFA67B5B),
            size: 24.0,
          ),
          label: Consumer(builder: (context, ref, _) {
            final selectedNotes = ref
                .watch(selectedNotesControllerProvider(NoteType.folderNotes));
            return Text(
              '${selectedNotes.length} selected',
              style: Styles.w500texts(
                  fontSize: 20.0, color: const Color(0xFFA67B5B)),
            );
          }),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0, top: 8.0),
          child: PopupMenuButton<FolderNoteAction>(
            icon: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFA67B5B),
                  width: 1,
                ),
                color: colorScheme.surface,
              ),
              child: Icon(
                Icons.more_horiz,
                size: 15.0,
                color: const Color(0xFFA67B5B),
              ),
            ),
            color: colorScheme.surfaceContainer,
            constraints: BoxConstraints(minWidth: 120.0),
            onSelected: (FolderNoteAction action) async {
              //Useful values
              final selectedNotes = ref
                  .read(selectedNotesControllerProvider(NoteType.folderNotes));
              final currentFolder = ref.read(foldersListProvider).firstWhere(
                  (folder) => folder.id == currentlyClickedFolder);
              final isMultipleNotesSelected = selectedNotes.length > 1;
              switch (action) {
                case FolderNoteAction.delete:
                  String type =
                      isMultipleNotesSelected ? 'Delete Notes' : 'Delete Note';
                  bool? confirmed =
                      await showConfirmationDialog(context, type: type);
                  if (confirmed == true) {
                    await notesController.deleteNote(selectedNotes);
                  }
                  break;

                case FolderNoteAction.addToOtherFolders:
                  final addedFolders =
                      await showAddToFoldersDialog(context, ref);
                  if (addedFolders == null || addedFolders.isEmpty) return;
                  foldersController.addToFolders(
                      notesToBeAdded: selectedNotes,
                      foldersToAdd: addedFolders);
                  break;

                case FolderNoteAction.removeFromFolder:
                  foldersController.removeFromFolder(
                      noteIds: selectedNotes, folder: currentFolder);
                  break;
              }
              clearSelection();
            },
            itemBuilder: (context) {
              //Useful values
              final selectedNotes = ref
                  .read(selectedNotesControllerProvider(NoteType.folderNotes));
              final isMultipleNotesSelected = selectedNotes.length > 1;
              return [
                PopupMenuItem(
                  value: FolderNoteAction.delete,
                  child: Text(
                    isMultipleNotesSelected ? 'Delete Notes' : 'Delete Note',
                    style: Styles.w500texts(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem(
                  value: FolderNoteAction.addToOtherFolders,
                  child: Text(
                    'Add to other folders',
                    style: Styles.w500texts(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem(
                  value: FolderNoteAction.removeFromFolder,
                  child: Text(
                    'Remove from folder',
                    style: Styles.w500texts(fontSize: 14.0),
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}
