import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/note_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/note_selection_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';

enum NoteMenuAction { pin, unpin, delete, addToFolders }

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
                  case NoteMenuAction.pin:
                    await noteCudNotifier.pinNote(selectedNotes);
                    break;
                  case NoteMenuAction.unpin:
                    await noteCudNotifier.unPinNote(selectedPinnedNotes);
                    break;
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
                    break;
                  case NoteMenuAction.addToFolders:
                    // Add to folders logic here
                    break;
                }
                selectedPinnedNotifer.clearSelection();
                selectionNotifier.clearSelection();
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
                  selectedPinnedNotes.isEmpty
                      ? PopupMenuItem(
                          value: NoteMenuAction.pin,
                          child: Text(
                            'Pin note',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        )
                      : PopupMenuItem(
                          value: NoteMenuAction.unpin,
                          child: Text(
                            'Unpin note',
                            style: Styles.w500texts(fontSize: 15.0),
                          ),
                        ),
                  PopupMenuItem(
                    value: NoteMenuAction.delete,
                    child: Text('Delete Note',
                        style: Styles.w500texts(fontSize: 15.0)),
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
