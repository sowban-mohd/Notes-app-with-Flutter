import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/notes_list_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/should_select_all_notes_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/add_to_folders_dialog.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';

enum NoteMenuAction { pin, unpin, delete, addToFolders, selectOrDeselectAll }

class AppBarWithAllNotesOps extends ConsumerWidget
    implements PreferredSizeWidget {
  const AppBarWithAllNotesOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes =
        ref.watch(noteSelectionProvider(NoteType.all)); //List of selected notes
    final selectionNotifier = ref.read(noteSelectionProvider(NoteType.all)
        .notifier); //Access to selection notifier
    final selectedPinnedNotes =
        ref.watch(noteSelectionProvider(NoteType.pinned));
    final selectedPinnedNotifer =
        ref.read(noteSelectionProvider(NoteType.pinned).notifier);
    final noteCudNotifier = ref.read(noteOpsStateProvider.notifier);

    return AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextButton.icon(
            onPressed: () {
              selectionNotifier.clearSelection();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: colorScheme.primary,
              size: 24.0,
            ),
            label: Text('${selectedNotes.length} selected',
                style: Styles.w500texts(
                    fontSize: 20.0, color: colorScheme.primary)),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 8.0),
            child: PopupMenuButton<NoteMenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case NoteMenuAction.delete:
                    String type = selectedNotes.length > 1
                        ? 'Delete Notes'
                        : 'Delete Note';
                    bool? confirmed =
                        await showConfirmationDialog(context, type: type);
                    if (confirmed == true) {
                      await ref
                          .read(noteOpsStateProvider.notifier)
                          .deleteNote(noteIds: selectedNotes);
                    }
                    selectedPinnedNotifer.clearSelection();
                    selectionNotifier.clearSelection();
                    break;
                  case NoteMenuAction.selectOrDeselectAll:
                    ref
                        .read(shouldSelectAllNotesProvider.notifier)
                        .toggleSelection();
                  case NoteMenuAction.addToFolders:
                    final addedFolders =
                        await showAddToFoldersDialog(context, ref);
                    if (addedFolders == null || addedFolders.isEmpty) return;
                    final listOfNotes = ref.read(notesListProvider);
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
                    selectedPinnedNotifer.clearSelection();
                    selectionNotifier.clearSelection();
                    break;
                  case NoteMenuAction.pin:
                    await noteCudNotifier.pinNote(selectedNotes);
                    selectedPinnedNotifer.clearSelection();
                    selectionNotifier.clearSelection();
                    break;
                  case NoteMenuAction.unpin:
                    await noteCudNotifier.unPinNote(selectedPinnedNotes);
                    selectedPinnedNotifer.clearSelection();
                    selectionNotifier.clearSelection();
                    break;
                }
              },
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 1,
                  ),
                  color: colorScheme.surface,
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 15.0,
                  color: colorScheme.primary,
                ),
              ),
              color: colorScheme.surfaceContainer,
              constraints: BoxConstraints(minWidth: 120.0),
              itemBuilder: (context) {
                return [
                  selectedPinnedNotes.isNotEmpty
                      ? PopupMenuItem(
                          value: NoteMenuAction.unpin,
                          child: Text(
                            'Unpin note',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        )
                      : PopupMenuItem(
                          value: NoteMenuAction.pin,
                          child: Text(
                            'Pin note',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        ),
                  PopupMenuItem(
                    value: NoteMenuAction.delete,
                    child: Text('Delete Note',
                        style: Styles.w500texts(fontSize: 15.0)),
                  ),
                  PopupMenuItem(
                    value: NoteMenuAction.selectOrDeselectAll,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isAllSelected =
                            ref.watch(shouldSelectAllNotesProvider);
                        return Text(
                          isAllSelected ? 'Unselect All' : 'Select All',
                          style: Styles.w500texts(fontSize: 15.0),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: NoteMenuAction.addToFolders,
                    child: Text(
                      'Add to folders',
                      style: Styles.w500texts(fontSize: 15.0),
                    ),
                  ),
                ];
              },
            ),
          ),
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
