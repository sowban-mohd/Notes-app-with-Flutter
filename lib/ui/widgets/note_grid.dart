import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/notes_controller.dart';
import 'package:notetakingapp1/logic/search_controller.dart';
import 'package:notetakingapp1/logic/selected_notes_controller.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/logic/utils.dart';

class NoteGrid extends StatelessWidget {
  NoteGrid({super.key});

  final _notesController = Get.find<NotesController>();
  final _selectedNotesController = Get.find<SelectedNotesController>();
  final _searchController = Get.find<SearchControllerX>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notes = _notesController.notes.reversed
          .toList(); //Notes are reveresed to build newer cards first in listview
      //If notes are empty
      if (notes.isEmpty) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note,
              size: 50.0,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text('No notes yet!\nCreate one.',
                textAlign: TextAlign.center,
                style: Styles.universalFont(fontSize: 20.0)),
          ],
        ));
      }

      //If notes are not empty
      //Notes are filtered with searchquery
      final filterdNotes = _searchController.searchQuery.isEmpty
          ? notes //shows entire list of notes when no search query is provided
          : notes
              .where((note) =>
                  note['title']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.searchQuery) ||
                  note['content']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.searchQuery))
              .toList();

      // Notes are displayed in a gridview
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop(context)
                ? 6
                : isTablet(context)
                    ? 4
                    : 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 168 / 198,
          ),
          itemCount: filterdNotes.length,
          itemBuilder: (context, index) {
            //Essential values
            final note = filterdNotes[index];
            final int key = note['key'];
            final String title = note['title'];
            final String content = note['content'];
            final bool hasTitle = title.trim().isNotEmpty;
            final bool hasContent = content.trim().isNotEmpty;

            //Note Card
            return GestureDetector(
                //When tapped
                onTap: () {
              Get.to(() => NoteEditingscreen(), arguments: key);
            },
                //When long pressed
                onLongPress: () {
              _selectedNotesController.toggleSelection(key);
            }, child: Obx(() {
              final isSelected = _selectedNotesController.isSelected;
              return Card(
                elevation: isSelected(key) ? 3.0 : 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: isSelected(key)
                      ? BorderSide(color: colorScheme.primary, width: 2.0)
                      : BorderSide.none,
                ),
                color: colorScheme.surfaceContainer,
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasTitle) ...[
                        Text(
                          title,
                          style: Styles.w600texts(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3),
                        Divider(),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                      hasContent
                          ? Flexible(
                              child: Text(content,
                                  style: Styles.w300texts(
                                      color: colorScheme.onSurface,
                                      fontSize: 14),
                                  overflow: TextOverflow.fade),
                            )
                          : Text(
                              'No content',
                              style: Styles.w300texts(
                                  color: colorScheme.onSurface.withAlpha(102),
                                  fontSize: 14),
                            ),
                    ],
                  ),
                ),
              );
            }));
          });
    });
  }
}
