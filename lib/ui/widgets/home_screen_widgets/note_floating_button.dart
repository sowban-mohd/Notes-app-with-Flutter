import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteFloatingButton extends ConsumerWidget {
  const NoteFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providers access
    final selectedNotes = ref.watch(selectionProvider); //List of selected notes
    final selectionNotifier = ref.read(selectionProvider.notifier);
    return selectedNotes.isNotEmpty
        ?
        //Delete note button
        FloatingActionButton(
            tooltip: 'Delete note',
            onPressed: () async {
              String type =
                  selectedNotes.length > 1 ? 'Delete notes' : 'Delete note';
              bool? confirmed =
                  await showConfirmationDialog(context, type: type);
              if (confirmed == true) {
                await ref
                    .read(deleteNoteProvider.notifier)
                    .deleteNote(selectedNotes);
                selectionNotifier.clearSelection();
              }
            },
            elevation: 2.0,
            backgroundColor: colorScheme.error,
            child: Icon(
              Icons.delete,
              color: colorScheme.onError,
            ),
          )
        :
        //Create note button
        FloatingActionButton(
            tooltip: 'Create a new note',
            onPressed: () {
              context.go('/note');
            },
            elevation: 2.0,
            backgroundColor: colorScheme.primary,
            child: Icon(Icons.edit, color: colorScheme.onPrimary),
          );
  }
}
