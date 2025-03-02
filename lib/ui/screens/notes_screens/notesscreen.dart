import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/notes_controller.dart';
import 'package:notetakingapp1/ui/screens/notes_screens/noteeditingscreen.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/note_grid.dart';
import 'package:notetakingapp1/ui/widgets/search_bar.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  final _notesController = Get.find<NotesController>();
  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date

  @override
  Widget build(BuildContext context) {
    final selectedNotes = _notesController.selectedNotes;
    //UI
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: selectedNotes.isNotEmpty
            ?
            //App bar when notes are selected
            AppBar(
                backgroundColor: colorScheme.surfaceContainerLowest,
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          selectedNotes.clear();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                          size: 20.0,
                        ),
                        label: Text('${selectedNotes.length} selected',
                            style: Styles.w500texts(
                                fontSize: 20.0, color: colorScheme.onSurface)),
                      ),
                    ]))
            :
            //Normal app bar
            AppBar(
                elevation: 0.0,
                backgroundColor: colorScheme.surface,
                title: Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Date and Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: Styles.w400texts(
                              fontSize: 12.0,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Notes',
                            style: Styles.titleStyle(fontSize: 24.0),
                          ),
                        ],
                      ),

                      //Log out button
                      IconButton(
                        tooltip: 'Log Out',
                        onPressed: () async {
                          //
                        },
                        icon: Icon(
                          Icons.logout,
                        ),
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ],
                  ),
                ),
              ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Column(
              children: [
                if (_notesController.selectedNotes.isEmpty) ...[
                  //Search bar
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: isDesktop(context) ? 18.0 : 10.0),
                    child: SearchBarWidget(),
                  ),
                ], //Search bar is hidden when note selection is on

                //Notes grid
                NoteGrid()
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
            child: selectedNotes.isNotEmpty
                ?
                //Delete note button
                FloatingActionButton(
                    tooltip: 'Delete note',
                    onPressed: () async {},
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
                      Get.to(NoteEditingscreen());
                    },
                    elevation: 2.0,
                    backgroundColor: colorScheme.primary,
                    child: Icon(Icons.edit, color: colorScheme.onPrimary),
                  )));
  }
}
