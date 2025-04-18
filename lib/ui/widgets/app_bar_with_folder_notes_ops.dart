import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/note_ops_state_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';

class AppBarWithFolderNotesOps extends ConsumerWidget
    implements PreferredSizeWidget {
  const AppBarWithFolderNotesOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes =
        ref.watch(folderNoteSelectionProvider); //List of selected notes
    final selectionNotifier = ref.read(
        folderNoteSelectionProvider.notifier); //Access to selection notifier
    final folder = ref.watch(categoryProvider);

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
              color: const Color(0xFFA67B5B),
              size: 24.0,
            ),
            label: Text('${selectedNotes.length} selected',
                style: Styles.w500texts(
                    fontSize: 20.0, color: const Color(0xFFA67B5B))),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 8.0),
            child: PopupMenuButton(
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
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Delete Note',  style: Styles.w500texts(fontSize: 15.0),),
                    onTap: () async {
                      String type = selectedNotes.length > 1
                          ? 'Delete Notes'
                          : 'Delete Note';
                      bool? confirmed =
                          await showConfirmationDialog(context, type: type);
                      if (confirmed == true) {
                        await ref
                            .read(noteOpsStateProvider.notifier)
                            .deleteNote(noteIds: selectedNotes, folder: folder);
                        ref
                            .read(folderNoteSelectionProvider.notifier)
                            .clearSelection();
                      }
                    },
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Add to other folders',
                      style: Styles.w500texts(fontSize: 15.0),
                    ),
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Remove from folder',
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
