import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/notes_controller.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  final _notesController = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: NoteAppBar(),
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
          child: Obx(() {
            final notes = _notesController.notes;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //If notes are empty
                notes.isEmpty
                    ? EmptyNoteScreenBody() // Screen to display when notes list is empty
                    :
                    // If notes are not empty
                    SearchBarWidget(),
                NoteGrid(),
              ],
            );
          }),
        )),
        floatingActionButton: NoteFloatingButton());
  }
}
