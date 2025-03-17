import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/controllers.dart';
import 'package:notetakingapp1/ui/screens/noteeditingscreen.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets/confirmaton_dialog.dart';

class NoteFloatingButton extends StatelessWidget {
  NoteFloatingButton({super.key});
  final _notesController = Get.find<NotesController>();
  final _selectedNotesController = Get.find<SelectedNotesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedNotes = _selectedNotesController.selectedNotes;
      return Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
          child: selectedNotes.isNotEmpty
              ?
              //Delete note button
              FloatingActionButton(
                  tooltip: 'Delete note',
                  onPressed: () async {
                    String type = selectedNotes.length > 1
                        ? 'Delete Notes'
                        : 'Delete Note';
                    bool? confirmed = await showConfirmationDialog(type);
                    if (confirmed == true) {
                      await _notesController.deleteNote(selectedNotes.toList());
                    }
                    selectedNotes.clear();
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
                    Get.to(() => NoteEditingscreen());
                  },
                  elevation: 2.0,
                  backgroundColor: colorScheme.primary,
                  child: Icon(Icons.edit, color: colorScheme.onPrimary),
                ));
    });
  }
}
