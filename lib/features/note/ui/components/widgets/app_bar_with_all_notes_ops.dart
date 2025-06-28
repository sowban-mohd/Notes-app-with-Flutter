import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/features/note/controller/all_notes_controller.dart';
import 'package:notetakingapp1/features/note/controller/folders_controller.dart';
import 'package:notetakingapp1/features/note/controller/selected_notes_controller.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/add_to_folders_dialog.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/confirmaton_dialog.dart';

enum NoteMenuAction { pin, unpin, delete, addToFolders, copyNote }

class AppBarWithAllNotesOps extends ConsumerWidget {
  const AppBarWithAllNotesOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Selected Notes Providers
    final pinnedNotesSelectionProvider =
        selectedNotesControllerProvider(NoteType.pinnedNotes);
    final allNotesSelectionProvider =
        selectedNotesControllerProvider(NoteType.allNotes);

    //Selected Notes Controllers
    final selectedNotesController =
        ref.read(allNotesSelectionProvider.notifier);
    final selectedPinnedNotesController =
        ref.read(pinnedNotesSelectionProvider.notifier);

    final notesController = ref.read(allNotesControllerProvider.notifier);
    final foldersController = ref.read(foldersControllerProvider.notifier);

    void clearSelections() {
      selectedPinnedNotesController.clearSelection();
      selectedNotesController.clearSelection();
    }

    return AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        title: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextButton.icon(
            onPressed: () {
              clearSelections();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: colorScheme.primary,
              size: 24.0,
            ),
            label: Consumer(builder: (context, ref, _) {
              final selectedNotes = ref.watch(selectedNotesControllerProvider(
                  NoteType.allNotes)); //Rebuilds when new notes are selected
              return Text('${selectedNotes.length} selected',
                  style: Styles.w500texts(
                      fontSize: 18.0, color: colorScheme.primary));
            }),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 8.0),
            child: PopupMenuButton<NoteMenuAction>(
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
                //Useful Values
                final selectedPinnedNotes =
                    ref.read(pinnedNotesSelectionProvider);
                final multiplePinnedNotesSelected =
                    selectedPinnedNotes.length > 1;
                final selectedNotes = ref.read(allNotesSelectionProvider);
                final multipleNotesSelected = selectedNotes.length > 1;
                return [
                  selectedPinnedNotes.isNotEmpty
                      ? PopupMenuItem(
                          value: NoteMenuAction.unpin,
                          child: Text(
                            multiplePinnedNotesSelected
                                ? 'Unpin notes'
                                : 'Unpin note',
                            style: Styles.w500texts(fontSize: 14.0),
                          ),
                        )
                      : PopupMenuItem(
                          value: NoteMenuAction.pin,
                          child: Text(
                            multipleNotesSelected ? 'Pin notes' : 'Pin note',
                            style: Styles.w500texts(fontSize: 14.0),
                          ),
                        ),
                  PopupMenuItem(
                    value: NoteMenuAction.delete,
                    child: Text(
                        multipleNotesSelected ? 'Delete notes' : 'Delete note',
                        style: Styles.w500texts(fontSize: 14.0)),
                  ),
                  PopupMenuItem(
                    value: NoteMenuAction.addToFolders,
                    child: Text(
                      'Add to folders',
                      style: Styles.w500texts(fontSize: 14.0),
                    ),
                  ),
                  PopupMenuItem(
                    value: NoteMenuAction.copyNote,
                    child: Text(
                      multipleNotesSelected ? 'Copy notes' : 'Copy note',
                      style: Styles.w500texts(fontSize: 14.0),
                    ),
                  ),
                ];
              },
              onSelected: (value) async {
                //Useful Values
                final selectedPinnedNotes =
                    ref.read(pinnedNotesSelectionProvider);
                final selectedNotes = ref.read(allNotesSelectionProvider);
                final multipleNotesSelected = selectedNotes.length > 1;
                switch (value) {
                  case NoteMenuAction.delete:
                    String type =
                        multipleNotesSelected ? 'Delete Notes' : 'Delete Note';
                    bool? confirmed =
                        await showConfirmationDialog(context, type: type);
                    if (confirmed == true) {
                      await notesController.deleteNote(selectedNotes);
                    }
                    break;
                  case NoteMenuAction.addToFolders:
                    final addedFolders =
                        await showAddToFoldersDialog(context, ref);
                    if (addedFolders == null || addedFolders.isEmpty) return;
                    foldersController.addToFolders(
                        notesToBeAdded: selectedNotes,
                        foldersToAdd: addedFolders);
                    break;
                  case NoteMenuAction.pin:
                    await notesController.pinNote(selectedNotes);
                    break;
                  case NoteMenuAction.unpin:
                    await notesController.unPinNote(selectedPinnedNotes);
                    break;
                  case NoteMenuAction.copyNote:
                    await notesController.copyNote(selectedNotes);
                    break;
                }
                clearSelections();
              },
            ),
          ),
        ]);
  }
}
