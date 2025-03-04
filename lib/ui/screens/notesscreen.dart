import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/notes_controller.dart';
import 'package:notetakingapp1/ui/screens/noteeditingscreen.dart';
import 'package:notetakingapp1/ui/utils/confirmaton_dialog.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/widgets/note_app_bar.dart';
import 'package:notetakingapp1/ui/widgets/note_grid.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  final _notesController = Get.find<NotesController>();
  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: NoteAppBar(),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
              child: Column(
                children: [
                  Expanded(child: NoteGrid()),
                ],
              )),
        ),
        floatingActionButton: Obx(() {
          final selectedNotes = _notesController.selectedNotes;
          return Padding(
              padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
              child: selectedNotes.isNotEmpty
                  ?
                  //Delete note button
                  FloatingActionButton(
                      tooltip: 'Delete note',
                      onPressed: () async {
                        String type = selectedNotes.length > 1 ? 'Delete Notes' : 'Delete Note';
                        bool? confirmed = await showConfirmationDialog(type);
                        if(confirmed == true){
                          await _notesController.deleteNote(selectedNotes.toList()); }
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
        }));
  }
}
