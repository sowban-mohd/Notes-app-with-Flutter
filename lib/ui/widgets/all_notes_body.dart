import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/body_stream_provider.dart';
import 'package:notetakingapp1/logic/providers/search_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/empty_note_screen_body.dart';
import 'package:notetakingapp1/ui/widgets/notes_gridview.dart';

class AllNotesBody extends ConsumerWidget {
  const AllNotesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesStream = ref.watch(bodyStreamProvider);
    return notesStream.when(data: (notes) {
      if (notes.isEmpty) {
        return EmptyNoteScreenBody();
      }

      final query = ref.watch(searchProvider);
      final pinnedNotes =
          notes.where((note) => note['pinned'] == true).toList();
      final otherNotes =
          notes.where((note) => note['pinned'] == false).toList();
      final filteredPinnedNotes = filterNotes(pinnedNotes, query);
      final filteredOtherNotes = filterNotes(otherNotes, query);

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //If there are pinned notes, this list is added to the column in the scroll view
            if (filteredPinnedNotes.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                child: Text(
                  'Pinned Notes',
                  style: Styles.noteSectionTitle(),
                ),
              ),
              NotesGridView(notes: filteredPinnedNotes, isNotePinned: true),
              //If there both pinned and other notes are there, this section title is also added to the column
              if (filteredOtherNotes.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                  child: Text(
                    'Other Notes',
                    style: Styles.noteSectionTitle(),
                  ),
                ),
              ]
            ],
            //If there are no pinned notes, this list of widgets are added to the column
            if (filteredPinnedNotes.isEmpty) ...[
              Padding(
                padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                child: Text(
                  'All Notes',
                  style: Styles.noteSectionTitle(),
                ),
              ),
            ],
            NotesGridView(notes: filteredOtherNotes, isNotePinned: false),
          ],
        ),
      );
    }, error: (error, stacktrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('An error occured',
                style: Styles.universalFont(fontSize: 16.0)),
            TextButton(
              onPressed: () {
                ref.refresh(bodyStreamProvider);
              },
              child: Text(
                'Retry',
                style: Styles.textButtonStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ));
      return SizedBox.shrink();
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    });
  }
}
