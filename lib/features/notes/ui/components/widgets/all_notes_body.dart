import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/controller/all_notes_controller.dart';
import 'package:notetakingapp1/features/notes/controller/search_provider.dart';
import 'package:notetakingapp1/features/notes/ui/components/layouts/notes_grid_view.dart';
import 'package:notetakingapp1/core/utils.dart';

class AllNotesBody extends ConsumerWidget {
  const AllNotesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesStream = ref.watch(allNotesStream);
    return notesStream.when(
      loading: () {
        return Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        );
      },
      data: (notes) {
        final query = ref.watch(searchProvider).trim();
        final isSearching = query.isNotEmpty;

        final pinnedNotes = notes.where((note) => note.pinned == true).toList();
        final otherNotes = notes.where((note) => note.pinned == false).toList();

        final filteredPinnedNotes =
            isSearching ? Utils.filterNotes(pinnedNotes, query) : pinnedNotes;
        final filteredOtherNotes =
            isSearching ? Utils.filterNotes(otherNotes, query) : otherNotes;

        if (filteredPinnedNotes.isEmpty && filteredOtherNotes.isEmpty) {
          final message =
              isSearching ? 'No results!' : 'No notes yet!\nCreate one.';
          final icon = isSearching ? Icons.search_off : Icons.edit_note_sharp;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48.0, color: Colors.grey),
                const SizedBox(height: 8.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Styles.universalFont(fontSize: 16.0),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredPinnedNotes.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                  child: Text('Pinned Notes', style: Styles.noteSectionTitle()),
                ),
                NotesGridView(
                  notes: filteredPinnedNotes,
                  noteType: NoteType.pinnedNotes,
                ),
                if (filteredOtherNotes.isNotEmpty) ...[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                    child:
                        Text('Other Notes', style: Styles.noteSectionTitle()),
                  ),
                ],
              ],
              if (filteredPinnedNotes.isEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                  child: Text('All Notes', style: Styles.noteSectionTitle()),
                ),
              ],
              NotesGridView(
                  notes: filteredOtherNotes, noteType: NoteType.allNotes),
            ],
          ),
        );
      },
      error: (error, stacktrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 5),
              content: Text('Error : ${error.toString()}',
                  style: Styles.universalFont(fontSize: 16.0)),
            ),
          );
        });
        return SizedBox.shrink();
      },
    );
  }
}
