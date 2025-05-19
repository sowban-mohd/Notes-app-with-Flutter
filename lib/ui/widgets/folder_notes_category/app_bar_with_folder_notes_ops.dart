import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_list_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_ops_state_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/add_to_folders_dialog.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';

enum FolderNoteAction {
  delete,
  addToOtherFolders,
  removeFromFolder,
}

class AppBarWithFolderNotesOps extends ConsumerWidget
    implements PreferredSizeWidget {
  const AppBarWithFolderNotesOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(folderNoteSelectionProvider);
    final selectionNotifier = ref.read(folderNoteSelectionProvider.notifier);
    final folder = ref.watch(categoryProvider);
    final folderOpsNotifier =
        ref.watch(folderNotesOpsProvider(folder).notifier);

    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      title: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextButton.icon(
          onPressed: () {
            selectionNotifier.clearSelection();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color(0xFFA67B5B),
            size: 24.0,
          ),
          label: Text(
            '${selectedNotes.length} selected',
            style: Styles.w500texts(
                fontSize: 20.0, color: const Color(0xFFA67B5B)),
          ),
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
              switch (action) {
                case FolderNoteAction.delete:
                  String type =
                      selectedNotes.length > 1 ? 'Delete Notes' : 'Delete Note';
                  bool? confirmed =
                      await showConfirmationDialog(context, type: type);
                  if (confirmed == true) {
                    await folderOpsNotifier.removeFromFolder(
                        noteIds: selectedNotes);
                    await ref
                        .read(noteOpsStateProvider.notifier)
                        .deleteNote(noteIds: selectedNotes);
                  }
                  break;

                case FolderNoteAction.addToOtherFolders:
                  final addedFolders = await showAddToFoldersDialog(
                      context, ref,
                      currentFolder: folder);
                  if (addedFolders == null || addedFolders.isEmpty) return;
                  final listOfNotes = ref.read(folderNotesListProvider);
                  for (var noteId in selectedNotes) {
                    final note = listOfNotes
                        .firstWhere((note) => note['noteId'] == noteId);
                    final title = note['title'];
                    final content = note['content'];
                    for (var folder in addedFolders) {
                      ref
                          .read(folderNotesOpsProvider(folder).notifier)
                          .addToFolder(title: title, content: content);
                    }
                  }
                  selectionNotifier.clearSelection();
                  break;

                case FolderNoteAction.removeFromFolder:
                  folderOpsNotifier.removeFromFolder(noteIds: selectedNotes);
                  break;
              }
              selectionNotifier.clearSelection();
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: FolderNoteAction.delete,
                  child: Text(
                    'Delete Note',
                    style: Styles.w500texts(fontSize: 15.0),
                  ),
                ),
                PopupMenuItem(
                  value: FolderNoteAction.addToOtherFolders,
                  child: Text(
                    'Add to other folders',
                    style: Styles.w500texts(fontSize: 15.0),
                  ),
                ),
                PopupMenuItem(
                  value: FolderNoteAction.removeFromFolder,
                  child: Text(
                    'Remove from folder',
                    style: Styles.w500texts(fontSize: 15.0),
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
