import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/state_controllers.dart';
import 'package:notetakingapp1/logic/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  final _notesController = Get.find<NotesController>(); //Provides notes and related methods
  final _searchController = Get.find<SearchControllerX>(); //Provides user's search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: NoteAppBar(),
        body: SafeArea(
            // Main body of the screen
            child: Padding(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
          child: Obx(() {
            final query = _searchController.searchQuery.value; //Search query
            final pinnedNotes = _notesController.pinnedNotes; //Pinned notes list
            final otherNotes = _notesController.otherNotes; //Other notes list

            // Notes are filtered to match search query
            final filteredPinnedNotes = filterNotes(pinnedNotes, query);
            final filteredOtherNotes = filterNotes(otherNotes, query);

            return filteredPinnedNotes.isEmpty && filteredOtherNotes.isEmpty
                ? EmptyNoteScreenBody() //Body to display when notes are empty
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBarWidget(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //If pinned  notes are not empty
                              //Pinned section is displayed
                              //Section titles are displayed to distinugish both sections
                              if (filteredPinnedNotes.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 12.0, left: 16.0, bottom: 8.0),
                                  child: Text(
                                    'Pinned notes',
                                    style: Styles.noteSectionTitle(),
                                  ),
                                ),
                                //Pinned notes gridview
                                NotesGridView(
                                    notes: filteredPinnedNotes, isPinned: true),
                                    //If other notes are not empty
                                    //'Other notes' section title is also displayed to distinguish section                        
                                if (filteredOtherNotes.isNotEmpty) ...[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 12.0, left: 16.0, bottom: 8.0),
                                    child: Text(
                                      'Other notes',
                                      style: Styles.noteSectionTitle(),
                                    ),
                                  ),
                                ],
                              ],
                              //Other notes gridview
                              NotesGridView(
                                  notes: filteredOtherNotes, isPinned: false),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          }),
        )),
        floatingActionButton: NoteFloatingButton());
  }
}
